iRef = imread('midhun.jpg');
imshow(iRef);

%% CODE BEGINS HERE %%

FDetect = vision.CascadeObjectDetector;
EDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',4);
NDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',8);
LEDetect = vision.CascadeObjectDetector('LeftEye','MergeThreshold',2);
REDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold',2);

%% Returns Bounding Box values for face, eyes, nose
BBface1 = step(FDetect,iRef);

%% Locate face region in main figure
rectangle('Position',BBface1,'LineWidth',5,'LineStyle','-','EdgeColor','r');

BBeyes1 = step(EDetect,iRef);

for i = 1:size(BBeyes1,1)
    rectangle('Position',BBeyes1(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','b');
end

%% Left Eye Detect
BBLeye1 = step(LEDetect,iRef);
for i = 1:size(BBLeye1,1)
    rectangle('Position', BBLeye1(i,:), 'LineWidth',1,'LineStyle','-','EdgeColor','g');
end

%% Right Eye Detect
BBReye1 = step(REDetect,iRef);
for i = 1:size(BBReye1,1)
    rectangle('Position', BBReye1(i,:), 'LineWidth',1,'LineStyle','-','EdgeColor','y');
end

%% Nose Detect
BBnose1 = step(NDetect,iRef);
for i = 1:size(BBnose1,1)
    rectangle('Position',BBnose1(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','w');
end

%% MOUTH DETECTION %%
MDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',2);

BBmouth1 = step(MDetect,iRef);

for i = 1:size(BBmouth1,1)
    rectangle('Position',BBmouth1(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','b');
end