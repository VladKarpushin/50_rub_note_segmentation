% 2018-10-03
% function finds location of 50-rub note.
% boxImage - reference image containing the object of interest. Gray
% sceneImage - target image containing a cluttered scene. Gray

function newBoxPolygon = FindRect(boxImage, sceneImage)
newBoxPolygon = zeros(5,2);
%% Step 2: Detect Feature Points
% Detect feature points in both images.
boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

%% Step 3: Extract Feature Descriptors
% Extract feature descriptors at the interest points in both images.
[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%% Step 4: Find Putative Point Matches
% Match the features using their descriptors. 
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

%% 
% Display putatively matched features. 
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);

[h w] = size(matchedBoxPoints);
if h < 3
    return;
end

[h w] = size(matchedScenePoints);
if h < 3
    return;
end


%% Step 5: Locate the Object in the Scene Using Putative Matches
% |estimateGeometricTransform| calculates the transformation relating the
% matched points, while eliminating outliers. This transformation allows us
% to localize the object in the scene.
% [tform, inlierBoxPoints, inlierScenePoints] = ...
%     estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

[tform] = estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

%% 
% Get the bounding polygon of the reference image.
boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

%%
% Transform the polygon into the coordinate system of the target image.
% The transformed polygon indicates the location of the object in the
% scene.
newBoxPolygon = transformPointsForward(tform, boxPolygon);    
%newBoxPolygon = boxPolygon;

%%
% Display the detected object.
% figure;
% imshow(sceneImage);
% hold on;
% line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
% title('Detected Box');
