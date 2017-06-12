function color = ray_trace(ray, OBJs, LIGHTs, depth)
%% variables
% ambient coefficient
A = 0.2;
% direct illumination color
ilumi = [0 0 0];
% refection color
reflect = [0 0 0];
% refraction color
refract = [0 0 0];

obj_smoothness = 0.4;

% Reflectance and transmittance
R = 0;
T = 0;

%% see if ray hits any object
hit = isblocked(ray, OBJs, inf);
%% if hit a surface
if hit{1} == 1
    hit_point = hit{2};
    N = hit{3};
    obj_color = hit{5};
    obj_smoothness = hit{6};
    V = (ray.origin - hit_point) / norm(ray.origin - hit_point);
    d = ray.direction;
    if dot(N, d) <= 0
        n2 = hit{7}; % refractive idx of media 2
        n1 = 1;
    else
        n2 = 1;
        n1 = hit{7};
    end
    
    % Reflectance and transmittance
    R = (n2 - n1)^2/(n1 + n2)^2;
    T = 1 - R;

    for i = 1: length(LIGHTs)
        light = LIGHTs{i};
        % check if this point can reach the light
        L_d = (light.position - hit_point);
        tmp_ray.origin = hit_point;
        tmp_ray.direction = L_d/norm(L_d);
        shadow = isblocked(tmp_ray, OBJs, norm(L_d));
        
        % always do ambient
        ambient = A * obj_color .* light.color;
        ilumi = ilumi + ambient;
        % if not shadowed ->  do specular + diffuse
        if ~(shadow{1} == 1 && shadow{4} < norm(L_d))
            L = L_d / norm(L_d);
            ilumi = Phong_shading(N, L, V, obj_color, light) + ilumi;
        end
    end
    
    % Reflection
    if depth > 0
       ray_refl.origin = hit_point;
       ray_refl.direction = d - 2 * dot(d, N) * N;
       reflect = ray_trace(ray_refl, OBJs, LIGHTs, depth - 1);
    end
    
    % Refraction
    if depth > 0
       ray_refr.origin = hit_point;
       ray_refr.direction = n1*(d - N * dot(d, N))/n2 ...
           - N * sqrt(1 - n1^2* (1 - dot(d, N)^2)/n2^2 );
       refract = ray_trace(ray_refr, OBJs, LIGHTs, depth - 1);
    end
    
end
% 2: 0.5, 0.02, 0.48
% 3: 0.5, 0.1, 0.4
% 4: 0.5, 0.25, 0.25
% 5: s = 0.1
% 6: s = 0.4
%% return
% color = 0.5 * ilumi + R * reflect + T * refract;
% color = 0.5 * ilumi + 0.25 * reflect + 0.25 * refract;
color = (1 - obj_smoothness) * ilumi + obj_smoothness * (reflect + refract);

% found if there is overflow
for i = 1:3
    if color(i) > 1
        color(i) = 1;
    end
end
end