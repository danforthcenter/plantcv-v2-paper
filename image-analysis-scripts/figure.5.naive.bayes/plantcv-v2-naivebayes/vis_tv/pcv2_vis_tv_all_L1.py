#!/usr/bin/env python

import numpy as np
import argparse
import plantcv as pcv


def options():
    parser = argparse.ArgumentParser(description="Imaging processing with opencv")
    parser.add_argument("-i", "--image", help="Input image file.", required=True)
    parser.add_argument("-o", "--outdir", help="Output directory for image files.", required=False)
    parser.add_argument("-m", "--roi", help="Input region of interest file.",
                        default="~/plantcv/masks/vis_tv/mask_brass_tv_z1_L1.png")
    parser.add_argument("-r", "--result", help="result file.", required=False)
    parser.add_argument("-r2", "--coresult", help="result file.", required=False)
    parser.add_argument("-w", "--writeimg", help="write out images.", default=False, action="store_true")
    parser.add_argument("-D", "--debug", help="Turn on debug, prints intermediate images.", action="store_true")
    args = parser.parse_args()
    return args


# Main pipeline
def main():
    # Get options
    args = options()

    # Read image
    img, path, filename = pcv.readimage(args.image)
    # brass_mask = cv2.imread(args.roi)

    # Pipeline step
    device = 0

    device, mask = pcv.naive_bayes_classifier(img, "naive_bayes.pdf.txt", device, args.debug)

    mask1 = np.uint8(mask)

    mask_copy = np.copy(mask1)

    # Fill small objects
    device, soil_fill = pcv.fill(mask1, mask_copy, 1500, device, args.debug)

    # Median Filter
    device, soil_mblur = pcv.median_blur(soil_fill, 11, device, args.debug)
    device, soil_cnt = pcv.median_blur(soil_fill, 11, device, args.debug)

    # Apply mask (for vis images, mask_color=white)
    device, masked2 = pcv.apply_mask(img, soil_cnt, 'white', device, args.debug)

    # Identify objects
    device, id_objects, obj_hierarchy = pcv.find_objects(masked2, soil_cnt, device, args.debug)

    # Define ROI
    device, roi1, roi_hierarchy = pcv.define_roi(img, 'circle', device, None, 'default', args.debug, True, 0, 50, -1500,
                                                 -1500)

    # Decide which objects to keep
    device, roi_objects, hierarchy3, kept_mask, obj_area = pcv.roi_objects(img, 'partial', roi1, roi_hierarchy,
                                                                           id_objects, obj_hierarchy, device,
                                                                           args.debug)

    # Object combine kept objects
    device, obj, mask = pcv.object_composition(img, roi_objects, hierarchy3, device, args.debug)

    # ############# Analysis ################

    # output mask
    device, maskpath, mask_images = pcv.output_mask(device, img, mask, filename, args.outdir, True, args.debug)

    # Find shape properties, output shape image (optional)
    device, shape_header, shape_data, shape_img = pcv.analyze_object(img, args.image, obj, mask, device, args.debug)

    # Determine color properties: Histograms, Color Slices and Pseudocolored Images,
    # output color analyzed images (optional)
    device, color_header, color_data, color_img = pcv.analyze_color(img, args.image, mask, 256, device, args.debug,
                                                                    None,
                                                                    'v', 'img', 300)

    result = open(args.result, "a")
    result.write('\t'.join(map(str, shape_header)))
    result.write("\n")
    result.write('\t'.join(map(str, shape_data)))
    result.write("\n")
    for row in mask_images:
        result.write('\t'.join(map(str, row)))
        result.write("\n")
    result.write('\t'.join(map(str, color_header)))
    result.write("\n")
    result.write('\t'.join(map(str, color_data)))
    result.write("\n")
    result.close()


if __name__ == '__main__':
    main()
