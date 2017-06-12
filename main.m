clear
tic
%% view
%eyes position
eyes = [2000; 0; 0];
% window
window_width = 667; window_height = 667; % need to be odd numbers
window = zeros(window_height,window_width,3);
window_center = [500; 0; 0];

%% scene
% objects list
OBJs = {};
% OBJs{i,1} -> object type, 0 for sphere, 1 for plane.
% OBJs{i,2} -> object
OBJs{1,1} = 0;
sphere1.center = [0; 0; -200];
sphere1.radius = 200;
sphere1.color = [1 0 0];
sphere1.smoothness = 0.5;
sphere1.n = 1.5;
OBJs{1,2} = sphere1;

OBJs{2, 1} = 1;
plane1.N = [ 0; 0; 1 ];
plane1.dist_to_origin = 400; % positive for origin located on the upper/right side.
plane1.color = [1 1 1];
plane1.smoothness = 0.2;
plane1.pt1 = [2000; 0; -plane1.dist_to_origin];
plane1.n = 3;
OBJs{2, 2} = plane1;

% lights list
LIGHTs = {}; 

% light1.position = [350; 350; 150];
for angle=1:9
    light1.position = [350*cos(40*angle*pi/180); 350*sin(40*angle*pi/180); 150];

light1.color = [1 1 1];
LIGHTs{1} = light1;

%% go trace
depth = 3; % maximum number of recursions for ray_trace
% for every pixel
for i = 1:window_height
    for j = 1:window_width
        cur_pix = window_center + [0; (window_width+1)/2; (window_height+1)/2] + [0; -j; -i];
        dir = cur_pix - eyes;
        ray.origin = cur_pix;
        ray.direction = dir / norm(dir);
%         ray.n = 1;      % record the refractive idx of media, in which the ray locates.
        window(i,j,:) = ray_trace(ray, OBJs, LIGHTs, depth);
    end
end
       
%% forming image
%image(window);
imwrite(window,['test_6angle_6_' +num2str(angle) +'.png']);
toc
end