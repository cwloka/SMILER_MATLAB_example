%% Script file for running the SMILER example "MATLAB noise experiment"
% Developed by Calden Wloka
% Last tested on SMILER version 1.0.0, January 2019

%% Perform setup operations

% find the images we want to process
imlist = dir('../images/stimuli/'); % note that we assume the stimuli folder ONLY contains input images
imlist = imlist(3:end); % hack to get rid of '..' and '.' elements

% decide which saliency models we want to use
models = {'AIM', 'FES', 'GBVS', 'IMSIG', 'RARE2012'};

% convert those models into function handles so we can execute them
modfun = cell(length(models),1);
for i = 1:length(models)
    modfun{i} = str2func([models{i}, '_wrap']);
end

% set up a SMILER parameter structure; note that this could be skipped if
% we want to use only default values, but in this case we want to turn off
% any explicit center biasing, because psychophysical search arrays are 
% unlikely to include such a bias
params = struct();
params.center_prior = 'none';

% set up a dilation for the target and distractor maps
dil = 10;

% now set the noise parameters
pointprops = [0, 0.001, 0.005, 0.01, 0.05, 0.1];
blurprops = [0, 0.001, 0.005, 0.01, 0.05];

% allocate the results arrays
point_results = cell(length(models),1);
blur_results = cell(length(models),1);
for i = 1:length(models)
    point_results{i} = zeros(length(imlist),length(pointprops));
    blur_results{i} = zeros(length(imlist),length(blurprops));
end

% set up some flags for saving images
flag_save_examples = true;
flag_point = [0, 0.01, 0.1]; % choose the point noise settings that we save images from
flag_blur = [0, 0.01, 0.05]; % choose the blur noise settings that we save images from
output_path = '../images/output';

if(flag_save_examples)
    if(~exist(output_path, 'dir'))
        mkdir(output_path);
    end
end

%% Run the experiment
% loop through the experiment images and calculate the saliency maps
for i = 1:length(imlist)
    img = im2double(imread(['../images/stimuli/', imlist(i).name]));
    targmap = imread(['../images/targmap/', imlist(i).name]);
    targmap = targmap(:,:,1); % make sure it is only single channel
    distmap = imread(['../images/distmap/', imlist(i).name]);
    distmap = distmap(:,:,1); % make sure it is only single channel
    
    % loop through point noise
    for j = 1:length(pointprops)
        % degrade image by noise
        if(pointprops(j) > 0)
            testimg = pointnoise(img, pointprops(j));
        else
            testimg = img;
        end
        
        % run saliency models
        for k = 1:length(models)
            salmap = modfun{k}(testimg, params); % execute the kth model on the test image
            point_results{k}(i,j) = maxrat(salmap, targmap, dil, distmap);
            
            if(flag_save_examples)
                if(ismember(pointprops(j), flag_point))
                    if(~exist(['../images/output/pn_', num2str(pointprops(j)), '_', imlist(i).name], 'file'))
                        imwrite(testimg, ['../images/output/pn_', num2str(pointprops(j)), '_', imlist(i).name]);
                    end
                    imwrite(salmap, ['../images/output/pn_', num2str(pointprops(j)), '_', models{k}, '_', imlist(i).name]);
                end
            end
        end
    end
    
    % loop through blurring
    for j = 1:length(blurprops)
        % degrade image by noise
        if(blurprops(j) > 0)
            testimg = blurnoise(img, blurprops(j));
        else
            testimg = img;
        end
        
        % run saliency models
        for k = 1:length(models)
            salmap = modfun{k}(testimg, params); % execute the kth model on the test image
            blur_results{k}(i,j) = maxrat(salmap, targmap, dil, distmap);
            
            if(flag_save_examples)
                if(ismember(blurprops(j), flag_blur))
                    if(~exist(['../images/output/bn_', num2str(blurprops(j)), '_', imlist(i).name], 'file'))
                        imwrite(testimg, ['../images/output/bn_', num2str(blurprops(j)), '_', imlist(i).name]);
                    end
                    imwrite(salmap, ['../images/output/bn_', num2str(blurprops(j)), '_', models{k}, '_', imlist(i).name]);
                end
            end
        end
    end
end 

%% Plot results
% set up some distinct colours for plotting the models on the same figure
colmat = [0, 0, 0.5; 0.5, 0, 0; 0, 0.7, 0; 0.7, 0, 0.7; 0, 0.4, 0.4];

% for plot titles here are some hardcoded names for the images
% note: this is a hack, and will break if you add more images
imnames = {'shape search image', 'flipped human search image'};

% loop through the models and plot each set of ratios
for i = 1:length(imlist)
    ph = figure();
    bh = figure();
    for j = 1:length(models)
        figure(ph);
        hold on
        plot(pointprops, point_results{j}(i,:), 'Color', colmat(j,:), 'LineWidth', 2)
        
        figure(bh);
        hold on
        plot(blurprops, blur_results{j}(i,:), 'Color', colmat(j,:), 'LineWidth', 2)
    end
    figure(ph)
    title(['The affect of point noise on target-distractor saliency ratios in the ', imnames{i}]);
    ylabel('Ratio of maximum target to distractor salience');
    xlabel('Proportion of pixels affected by point noise');
    legend(models);
    set(gcf, 'color', 'w');
    hold on
    plot([pointprops(1), pointprops(end)], [1,1], 'r:'); % add the error line
    
    % the next three lines are an undocumented hack in MATLAB to
    % automatically maximize the figures
    pause(0.000001);
    frame_h = get(ph, 'JavaFrame');
    set(frame_h, 'Maximized', 1);
    
    figure(bh)
    title(['The affect of blurring noise on target-distractor saliency ratios in the ', imnames{i}]);
    ylabel('Ratio of maximum target to distractor salience');
    xlabel('Size of blurring kernel sigma as a proportion of image major axis');
    legend(models);
    set(gcf, 'color', 'w');
    hold on
    plot([blurprops(1), blurprops(end)], [1,1], 'r:'); % add the error line
    
    % the next three lines are an undocumented hack in MATLAB to
    % automatically maximize the figures
    pause(0.000001);
    frame_h = get(bh, 'JavaFrame');
    set(frame_h, 'Maximized', 1);
end