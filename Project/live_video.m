clf
close all

%% Setup the Kinect acquisition variables
% Number of seconds 
N = 60; 

% Acquire data into memory before logging it
colorVid = videoinput('kinect',1); 
depthVid = videoinput('kinect',2);

% Set Kinect Properties
set([colorVid depthVid], 'FramesPerTrigger', 1);
set([colorVid depthVid], 'TriggerRepeat', Inf);
triggerconfig([colorVid depthVid], 'manual')

%% Start the color and depth device. This begins acquisition, but does not
% start logging of acquired data.
start([colorVid depthVid]);

%% Trigger the devices to start logging of data.
trigger([colorVid depthVid]);

[rframe, rts, rmetaData] = getdata(colorVid); 
[dframe, dts, dmetaData] = getdata(depthVid);

figure; h1 = imshow(rframe); 
figure; h2 = imagesc(dmetaData.SegmentationData); 

%%
disp('Starting data acquisition...')
t0 = tic; t = 0;
while(ishandle(h1) && ishandle(h2))
    t = toc(t0); 
    trigger([colorVid depthVid]);
    [rframe, rts, rmetaData] = getdata(colorVid); 
    [dframe, dts, dmetaData] = getdata(depthVid);
    set(h1,'Cdata',rframe);
    set(h2,'Cdata',dmetaData.SegmentationData)
    dmetaData.IsSkeletonTracked
    drawnow
end

%% Clean up
delete(colorVid)
delete(depthVid)
clear colorVid
clear depthVid