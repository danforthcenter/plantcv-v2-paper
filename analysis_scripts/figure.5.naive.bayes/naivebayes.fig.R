# Script for analysis of PlantCV vs PlantCV naive Bayes image analysis results
library(ggplot2)
library(gridExtra)
library(scales)

############################################
# Read data and format for analysis
############################################

# Read pcv2 data
pcv2.data <- read.table(file = "pcv2-areatest-050417.csv", sep = "\t", header = TRUE)

# read nb data
nb.data <- read.table(file = "pcv2-nb-areatest-050417.csv", sep = "\t", header = TRUE)

# Label genotypes from barcodes
pcv2.data$genotype <- NA
pcv2.data$genotype[grep("Dp1", pcv2.data$plantbarcode)] <- "A10"
pcv2.data$genotype[grep("Dp2", pcv2.data$plantbarcode)] <- "B100"

nb.data$genotype <- NA
nb.data$genotype[grep("Dp1", pcv2.data$plantbarcode)] <- "A10"
nb.data$genotype[grep("Dp2", pcv2.data$plantbarcode)] <- "B100"

# Label treatments from barcodes
pcv2.data$treatment <- NA
pcv2.data$treatment[grep("AA", pcv2.data$plantbarcode)] <- 100
pcv2.data$treatment[grep("AB", pcv2.data$plantbarcode)] <- 0
pcv2.data$treatment[grep("AC", pcv2.data$plantbarcode)] <- 0
pcv2.data$treatment[grep("AD", pcv2.data$plantbarcode)] <- 33
pcv2.data$treatment[grep("AE", pcv2.data$plantbarcode)] <- 66

nb.data$treatment <- NA
nb.data$treatment[grep("AA", pcv2.data$plantbarcode)] <- 100
nb.data$treatment[grep("AB", pcv2.data$plantbarcode)] <- 0
nb.data$treatment[grep("AC", pcv2.data$plantbarcode)] <- 0
nb.data$treatment[grep("AD", pcv2.data$plantbarcode)] <- 33
nb.data$treatment[grep("AE", pcv2.data$plantbarcode)] <- 66

# Subset the data to keep a few columns
pcv2.sub <- subset(pcv2.data, select = c(image, camera, genotype, treatment, area, hull.area))

nb.sub <- subset(nb.data, select = c(image, camera, plantbarcode, genotype, treatment, area, hull.area))

# Merge the PlantCV2 and Naive Bayes datasets
merged <- merge(pcv2.sub, nb.sub, by = "image", all.x = FALSE, all.y = FALSE)

# Split the side-view and top-view data into two sets and remove the zero water treatment group
merged.sv <- merged[merged$camera.x == "SV" & merged$treatment.x != 0,]
merged.tv <- merged[merged$camera.x == "TV" & merged$treatment.x != 0,]

# Function for fitting a linear model to PlantCV2 vs Naive Bayes
lm_eqn = function(df) {
  # Fit a linear model
  m = lm(area.y ~ area.x, df)
  # Get the linear model equation
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(a = format(coef(m)[1], digits = 2), 
                        b = format(coef(m)[2], digits = 2), 
                        r2 = format(summary(m)$r.squared, digits = 4)))
  as.character(as.expression(eq));                 
}

# Get the equations for side-view and top-view comparisons
eq1 <- lm_eqn(merged.sv)
eq2 <- lm_eqn(merged.tv)

# Plot the side-view comparison
# Rescale x and y by 10,000 pixels
sv <- ggplot(merged.sv, aes(x = area.x / 1e5, y = area.y / 1e5)) +
  # Plot points, color by genotype
  geom_point(aes(group = genotype.x, color = genotype.x), size = 1) +
  # Add a linear model fit line
  geom_smooth(method = "lm", color = "black") +
  # Label the x-axis and set limits
  scale_x_continuous("PlantCV Shoot and leaf area (10^5 px)", limits = c(0, 4)) +
  # Label the y-axis and set limits
  scale_y_continuous("PlantCV Naive-Bayes Shoot and leaf area (10^5 px)", limits = c(0, 4)) +
  # Use the black and white theme
  theme_bw() +
  # Add the linear model and R^2 labels to the graph
  annotate("text", x = 0.5, y = 3, label = "y=1460 + 0.95x, R2=0.99") +
  # Position the legend and make the axis titles bold
  theme(legend.position = c(0.1, 0.8),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))
# Save the graph
ggsave(filename = "pcv2-nb-comparison-sv.pdf", plot = sv, width = 6, height = 6, useDingbats = FALSE)

# Plot the side-view comparison
# Rescale x and y by 10,000 pixels
tv <- ggplot(merged.tv, aes(x = area.x / 1e5, y = area.y / 1e5)) +
  # Plot points, color by genotype
  geom_point(aes(group = genotype.x, color = genotype.x), size = 1) +
  # Add a linear model fit line
  geom_smooth(method = "lm", color = "black") +
  # Label the x-axis and set limits
  scale_x_continuous("PlantCV Shoot and leaf area (10^5 px)", limits = c(0, 12), breaks = c(0, 2, 4, 6, 8, 10, 12)) +
  # Label the y-axis and set limits
  scale_y_continuous("PlantCV Naive-Bayes Shoot and leaf area (10^5 px)", limits = c(0, 12), breaks = c(0, 2, 4, 6, 8, 10, 12)) +
  # Use the black and white theme
  theme_bw() +
  # Add the linear model and R^2 labels to the graph
  annotate("text", x = 2, y = 8, label = "y=9787 + 1.1x, R2=0.96") +
  # Position the legend and make the axis titles bold
  theme(legend.position = c(0.1, 0.8),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))
# Save the graph
ggsave(filename = "pcv2-nb-comparison-tv.pdf", plot = tv, width = 6, height = 6, useDingbats = FALSE)
