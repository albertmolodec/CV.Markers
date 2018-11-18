import cv2
import numpy as np

image = cv2.imread("vlad3.jpg")
image = cv2.resize(image,(1280,640))

#Normalize
imageHSV = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

# тут определить промежуток цвета в HSV
lower_blue = np.array([90,50,50])
upper_blue = np.array([140,255,255])

mask = cv2.inRange(imageHSV, lower_blue, upper_blue)
kernel = np.ones((3,3),np.uint8)
opening = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)

(_, contours, hierarchy) = cv2.findContours(opening.copy(),cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_NONE)
# print(contours)
ref = np.zeros_like(opening)
cv2.drawContours(ref, np.asarray(contours), -1, 255, 1)

file = open("coords.txt", "a")
for contour in contours:
    M = cv2.moments(contour)
    centroid_x = int(M['m10']/M['m00'])
    centroid_y = int(M['m01']/M['m00'])
    file.write(str(centroid_x) + " " + str(centroid_y) + "\n")
    cv2.circle(ref,(centroid_x, centroid_y), 2, 255, -1)
file.close()    


cv2.imshow("image", imageHSV)
cv2.imshow("mask", opening)
cv2.imshow("contours", ref)
k = cv2.waitKey(0)    
cv2.destroyAllWindows()