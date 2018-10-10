close all,clc,clear all;

% Object Detection in a Cluttered Scene Using Point Feature Matching
% This example shows how to detect a particular object in a cluttered scene,
% given a reference image of the object. 

% Overview
% This example presents an algorithm for detecting a specific object based 
% on finding point correspondences between the reference and the target 
% image. It can detect objects despite a scale change or in-plane 
% rotation. It is also robust to small amount of out-of-plane rotation and 
% occlusion.
%
% This method of object detection works best for objects that exhibit
% non-repeating texture patterns, which give rise to unique feature matches. 
% This technique is not likely to work well for uniformly-colored objects, 
% or for objects containing repeating patterns. Note that this algorithm is
% designed for detecting a specific object, for example, the elephant in 
% the reference image, rather than any elephant. For detecting objects of a
% particular category, such as people or faces, see |vision.PeopleDetector| 
% and |vision.CascadeObjectDetector|.

% Copyright 1993-2014 The MathWorks, Inc. 

% Step 1: Read Images
% Read the reference image containing the object of interest.
boxImage = imread('../images/50_2.jpg');
[h w c] = size(boxImage);
if c == 3
    boxImage = rgb2gray(boxImage);
end
figure;
imshow(boxImage);
title('Image of a Box');

%
% Read the target image containing a cluttered scene.
%sceneImage = imread('images/P1030591.JPG');
%sceneImage = imread('images/input.JPG');
%sceneImage = imread('images/21.JPG');
%sceneImage = imread('images/34.JPG');
sceneImage = imread('../images/34.JPG');

[h w c] = size(sceneImage);
if c == 3
    sceneImage = rgb2gray(sceneImage);
end
figure; 
imshow(sceneImage);
title('Image of a Cluttered Scene');

newBoxPolygon = FindRect(boxImage, sceneImage);

figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');
