function [ t ] = RayPlaneIntersect( ray, plane )

if dot(ray.direction, plane.N) == 0
    t = -1;
    return
else
    t = dot(plane.N, plane.pt1 - ray.origin)/dot(ray.direction, plane.N);
    return
end 
end

