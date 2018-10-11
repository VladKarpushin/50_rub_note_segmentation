# 2018-10-10
# A task for azoft. 
# 1. Реализовать скрипт, который в реальном времени находит 50-рублевую купюру на изображениях с вебкамеры.

import numpy as np
import cv2 as cv

MIN_MATCH_COUNT = 10

def FindRect(img1, img2):
    #-- Step 1: Initiate SIFT/SURF detector and find the keypoints and descriptors with SIFT
    detector = cv.xfeatures2d.SIFT_create()
    #minHessian = 400
    #detector = cv.xfeatures2d.SURF_create(hessianThreshold=minHessian)
    kp1, des1 = detector.detectAndCompute(img1,None)
    kp2, des2 = detector.detectAndCompute(img2,None)

    #-- Step 2: Matching descriptor vectors
    FLANN_INDEX_KDTREE = 1
    index_params = dict(algorithm = FLANN_INDEX_KDTREE, trees = 5)
    search_params = dict(checks = 50)
    flann = cv.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1,des2,k=2)

    # store all the good matches
    good = []
    for m,n in matches:
        if m.distance < 0.7*n.distance:
            good.append(m)

    if len(good)>MIN_MATCH_COUNT:
        src_pts = np.float32([ kp1[m.queryIdx].pt for m in good ]).reshape(-1,1,2)
        dst_pts = np.float32([ kp2[m.trainIdx].pt for m in good ]).reshape(-1,1,2)
        M, mask = cv.findHomography(src_pts, dst_pts, cv.RANSAC,5.0)
        matchesMask = mask.ravel().tolist()
        h,w = img1.shape
        pts = np.float32([ [0,0],[0,h-1],[w-1,h-1],[w-1,0] ]).reshape(-1,1,2)
        if M is not None:
            dst = cv.perspectiveTransform(pts,M)
            img2 = cv.polylines(img2,[np.int32(dst)],True,255,3, cv.LINE_AA)    # Draw boiding rect with white color
        else:
            print('M is None')
    else:
        print( "Not enough matches are found - {}/{}".format(len(good), MIN_MATCH_COUNT) )
        matchesMask = None

    #-- Step 3: Draw matches
    draw_params = dict(matchColor = (0,255,0), # draw matches in green color
                       singlePointColor = None,
                       matchesMask = matchesMask, # draw only inliers
                       flags = 2)
    img3 = cv.drawMatches(img1,kp1,img2,kp2,good,None,**draw_params)
    return img3

def main():
    print('Processing is started')
    img1 = cv.imread('..\\images\\50_2.jpg', cv.IMREAD_GRAYSCALE)           # box   (queryImage)
    #img2 = cv.imread('..\\images\\P1030591.JPG', cv.IMREAD_GRAYSCALE)       # scene (trainImage)
    #if img1 is None or img2 is None:
    if img1 is None:
        print('Could not open or find the images!')
        exit(0)

    cap = cv.VideoCapture(0)
    while(1):
        ret, frame = cap.read()
        if ret == True:
            img2 = cv.cvtColor(frame,cv.COLOR_BGR2GRAY)
            img3 = FindRect(img1, img2)
            cv.imshow('img3',img3)
            k = cv.waitKey(60) & 0xff
            if k == 27:
                print('k == 27')
                break
        else:
            break
    cv.destroyAllWindows()
    cap.release()

    #img3 = FindRect(img1, img2)
    #-- Show detected matches
    #cv.imwrite('..\\output\\out.jpg',img3)
    #cv.waitKey()
    print('Processing is finished')

I = main() 