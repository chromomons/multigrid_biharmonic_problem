function gen_mesh_rectangle(N, M, xmin, xmax, ymin, ymax)

% function gen_mesh_rectangle(N, M, xmin, xmax, ymin, ymax)
%
% generates a uniform mesh of the rectangle
%        [xmin, xmax] x [ymin, ymax]
% dividing it into  NxM  subrectangles
% and then each subrectangle into two triangles
%
% four files will be generated:
%   elem_vertices.txt
%   vertex_coordinates.txt
%       describe the geometry of the mesh
%   dirichlet.tbxt
%       with the list of Dirichlet vertices
%   neumann.txt
%       with the list of segments on the Neumann part
%       of the boundary (empty on this version)
%
%
% if only  gen_mesh_rectangle(N)  is invoked
% a uniform NxN mesh of the unit square [0,1]^2 will be generated

% the numbering of vertices and elements is as follows
%
% (N+1)M +---+---+---+---+(N+1)(M+1)
%        | / | / | / | / |
%        +---+---+---+---+
%        | / | / | / | / |
%    N+2 +---+---+---+---+N+2+N
%        |1/2|3/4| / | / |
%        +---+---+---+---+
%        1   2   ...     N+1

if (nargin == 1)
  M = N;
  xmin = 0;
  xmax = 1;
  ymin = 0;
  ymax = 1;
end

% first the vertex coordinates
deltax = (xmax - xmin)/N;
deltay = (ymax - ymin)/M;

file = fopen('vertex_coordinates.txt', 'wt');
for i = 0 : M
  for j = 0 : N
    fprintf(file, '%8.4f  %8.4f \n', xmin + j*deltax, ymin + i*deltay);
  end
end
fclose(file);

% now the description of the elements
file = fopen('elem_vertices.txt', 'wt');
for i = 0 : M-1
  for j = 1 : N
    fprintf(file, '%4d  %4d  %4d \n', ...
	    i*(N+1)+j , (i+1)*(N+1)+j+1, (i+1)*(N+1)+j );
    fprintf(file, '%4d  %4d  %4d \n', ...
	    (i+1)*(N+1)+j+1, i*(N+1)+j , i*(N+1)+j+1 );
  end
end
fclose(file);

% This function generates files to solve problems on domains
% with the whole boundary of  Dirichlet  type.

% For that reason, the file 'dirichlet.txt' should contain
% all the boundary vertices and  'newmann.txt'  should be empty.

% Now we create  'dirichlet.txt'  
file = fopen('dirichlet.txt', 'wt');
% first the nodes at the base (y = ymin)
for j = 1 : N+1
  fprintf(file, '%4d \n', j);
end
% next the nodes at the lateral sides (x = xmin  or  x = xmax)
for i = 1 : M-1
    fprintf(file, '%4d \n', i*(N+1)+1);    %  izquierda
    fprintf(file, '%4d \n', i*(N+1)+N+1);  %  derecha
end
% finally the nodes at the top (y = ymax)
for j = 1 : N+1
  fprintf(file, '%4d \n', (N+1)*M+j);
end
fclose(file);

% now we delete (if exists) the file 'neumann.txt'
%system('rm -f neumann.txt'); % unix/linux version
%system('del neumann.txt');   % windows version

