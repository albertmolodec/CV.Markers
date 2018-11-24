import cv2
import numpy as np

def getKey(item):
    return item[0]

image = cv2.imread("input/markered/box_right.jpg")
image = cv2.resize(image,(1920,1080))

imageHSV = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

hsv_min = np.array([26,210,231])
hsv_max = np.array([255,255,255])

mask = cv2.inRange(imageHSV, hsv_min, hsv_max)
kernel = np.ones((3,3),np.uint8)
opening = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)

(_, contours, hierarchy) = cv2.findContours(opening.copy(),cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_NONE)
ref = np.zeros_like(opening)
cv2.drawContours(image, np.asarray(contours), -1, (0,0,255), 1)
coords_array = []

for contour in contours:
    M = cv2.moments(contour)
    cx = int(M['m10']/M['m00'])
    cy = int(M['m01']/M['m00'])
    coords_array.append([cx, cy])
  
font = cv2.FONT_HERSHEY_SIMPLEX 
coords_array = sorted(coords_array, key = getKey)
file = open("output/box/box_right.txt", "a")
file.write(str(len(coords_array)) + "\n")
for index, item in enumerate(coords_array):
	cv2.putText(image, str(index + 1), (int(item[0] + 10), int(item[1]) + 10), font, 1, (0,242,255), 1, cv2.LINE_AA)
	cv2.circle(image,(item[0], item[1]), 2, (0, 0, 255), 2)
	file.write(str(item[0]) + " " + str(item[1]) + "\n")
file.close()  

cv2.imshow("image", image)
cv2.imwrite("output/box/box_right_coords.jpg", image)
cv2.imshow("mask", opening)
k = cv2.waitKey(0)    
cv2.destroyAllWindows()