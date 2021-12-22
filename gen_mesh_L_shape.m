function gen_mesh_L_shape(N)

% function gen_mesh_L_shape(N)
%
% generates a uniform mesh of the L-shaped domain
%     [-1,1]x[-1,1] - [0,1]x[-1,0]
%
% dividing each square into NxN subsquares
% and then each subsquare into two triangles
%
% four files will be generated:
%   elem_vertices.txt
%   vertex_coordinates.txt
%       describe the geometry of the mesh
%   dirichlet.txt
%       with the list of Dirichlet vertices
%   neumann.txt
%       with the list of segments on the Neumann part
%       of the boundary (empty on this version)

% the numbering of vertices and elements is as follows
%
%           ...
%        | / | / | / | / | / | / | / | / |
% (N+1)N +---+---+---+---+---+---+---+---+
%        | / | / | / | / |  (N+1)(N+1)
%        +---+---+---+---+
%        | / | / | / | / |
%    N+2 +---+---+---+---+N+2+N
%        |1/2|3/4| / | / |
%        +---+---+---+---+
%        1   2   ...     N+1

% first the vertex coordinates
deltax = 1/N;
deltay = 1/N;

file = fopen('vertex_coordinates.txt', 'wt');
xmin = -1; xmax = 0;
ymin = -1; ymax = 0;
for i = 0 : N-1
  for j = 0 : N
    fprintf(file, '%8.4f  %8.4f \n', ...
	    xmin + j*deltax, ymin + i*deltay);
  end
end
xmin = -1; xmax = 1;
ymin =  0; ymax = 1;
for i = 0 : N
  for j = 0 : 2*N
    fprintf(file, '%8.4f  %8.4f \n', ...
	    xmin + j*deltax, ymin + i*deltay);
  end
end
fclose(file);

% now comes the description of the elements
file = fopen('elem_vertices.txt', 'wt');
for i = 0 : N-1
  for j = 1 : N
    fprintf(file, '%4d  %4d  %4d \n', ...
	    i*(N+1)+j , (i+1)*(N+1)+j+1, (i+1)*(N+1)+j );
    fprintf(file, '%4d  %4d  %4d \n', ...
	    (i+1)*(N+1)+j+1, i*(N+1)+j , i*(N+1)+j+1 );
  end
end

first = (N+1)*N;
for i = 0 : N-1
  for j = 1 : 2*N
    fprintf(file, '%4d  %4d  %4d \n',  ...
	    first + i*(2*N+1)+j,        ...
	    first + (i+1)*(2*N+1)+j+1,  ...
	    first + (i+1)*(2*N+1)+j ); 
    fprintf(file, '%4d  %4d  %4d \n',  ...
	    first + (i+1)*(2*N+1)+j+1,  ...
	    first + i*(2*N+1)+j ,       ...
	    first + i*(2*N+1)+j+1 );
  end
end
fclose(file);


% This function generates files to solve problems on domains
% with the whole boundary of  Dirichlet  type.

% For that reason, the file 'dirichlet.txt' should contain
% all the boundary vertices and  'newmann.txt'  should be empty.

% Now we create  'dirichlet.txt'  
file = fopen('dirichlet.txt', 'wt');

% first the nodes at the base  (y = -1)
for j = 1 : N+1
  fprintf(file, '%4d \n', j);
end
% now the lateral sides of the lower part
%  ( -1 < y < 0 ) and ( (x = -1) or (x = 0) )
for i = 1 : N-1
    fprintf(file, '%4d \n', i*(N+1)+1);
    fprintf(file, '%4d \n', i*(N+1)+N+1);
end
fprintf(file, '%4d \n', N*(N+1)+1);

% now the vertices at the lower part of the upper part
%  ( y = 0 ) and ( 0 < x < 1 )
for j = 1 : N+1
  fprintf(file, '%4d \n', (N+1)*(N+1)+j-1);
end

% now the lateral sides of the upper part
%  ( 0 < y < 1 ) and ( (x = -1) or (x = -1) )
first = (N+1)*(N+1)+N;
for i = 1 : N-1
    fprintf(file, '%4d \n', first+(i-1)*(2*N+1)+1);
    fprintf(file, '%4d \n', first+(i-1)*(2*N+1)+2*N+1);
end

% finally the top part  ( y = 1 ) and ( -1 < x < 1 ) 
first = (2*N+1)^2 - N^2 - (2*N+1);
for j = 1 : 2*N+1
  fprintf(file, '%4d \n', first+j);
end
fclose(file);

