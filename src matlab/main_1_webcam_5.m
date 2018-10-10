% 2018-10-02
% A task for Azoft
% 1. Реализовать скрипт, который в реальном времени находит 50-рублевую купюру на изображениях с вебкамеры.

close all,clc,clear all;

% Read the reference image containing the object of interest.
boxImage = imread('../images/50_2.jpg');
boxImage = rgb2gray(boxImage);
figure;
imshow(boxImage);
title('Image of a Box');

clear cam;
% imaqhwinfo
% info = imaqhwinfo('dcam')
% %dev_info = imaqhwinfo('dcam',1)

camList = webcamlist

% Connect to the webcam.
cam = webcam(1)
cam.Resolution = char(cam.AvailableResolutions(19))
% Resolution = sscanf(cam.Resolution, '%dx%d');
% w = Resolution(1);
% h = Resolution(2);

%preview(cam);

frames = 50;
figure;
for i=1:frames
    sceneImage = snapshot(cam);
    sceneImage = rgb2gray(sceneImage);
    imwrite(sceneImage,strcat('../output/', num2str(i), '.jpg'));

    newBoxPolygon = FindRect(boxImage, sceneImage);
    imshow(sceneImage);
    hold on;
    line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
    %title('Detected Box');
    i
end
% pause
clear cam