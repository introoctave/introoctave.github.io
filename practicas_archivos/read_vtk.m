function [vertex,face] = read_vtk(filename)
% read_vtk - read data from VTK ASCII file.
% The VTK PolyData is a triangular mesh.
%   [vertex,face] = read_vtk(filename, verbose);
%
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 3' array specifying the connectivity of the mesh.
%
%   Copyright (C) Mario Richtsfeld and D Millan 2020


fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
end

str = fgets(fid);   % -1 if eof
if ~strcmp(str(3:5), 'vtk')
    error('The file is not a valid VTK one.');    
end

%%% read header %%%
fgets(fid);
fgets(fid);
str = fgets(fid);
if strcmp('ASCII',str) == 1
  error('The file must be in ASCII format')
end

%% extract number of nodes
str   = fgets(fid);
nvert = sscanf(str,'%*s %d %*s', 1);  % variables with '%*' are not returned!

%% read vertices
[A,cnt] = fscanf(fid,'%lf %lf %lf', 3*nvert);
if cnt~=3*nvert
    warning('Problem in reading vertices.')
end
vertex = reshape(A, 3, cnt/3)';

%% read polygons
fgets(fid);
str = fgets(fid);

info = sscanf(str,'%c %*s %*s', 1);

if((info ~= 'P') && (info ~= 'V'))
    str = fgets(fid);    
    info = sscanf(str,'%c %*s %*s', 1);
end

if(info == 'P')
    nface = sscanf(str,'%*s %d %*s', 1);

    [A,cnt] = fscanf(fid,'%d %d %d %d\n', 4*nface);
    if cnt~=4*nface
        warning('Problem in reading faces.');
    end

    A = reshape(A, 4, cnt/4);
    face = A(2:4,:)+1;
end

if(info ~= 'P')
    face = 0;
end

%% read vertex ids
if(info == 'V')
    
    nv = sscanf(str,'%*s %d %*s', 1);

    [A,cnt] = fscanf(fid,'%d %d \n', 2*nv);
    if cnt~=2*nv
        warning('Problem in reading faces.');
    end

    A = reshape(A, 2, cnt/2);
    face = repmat(A(2,:)+1, 3, 1);
end

if((info ~= 'P') && (info ~= 'V'))
    face = 0;
end
face   = face';

if nargout<3
  return
end

fclose(fid);

return