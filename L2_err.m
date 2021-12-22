function error = L2_err(elem_vertices, vertex_coordinates, uef, u)
% function error = L2_err(elem_vertices, vertex_coordinates, uef, u)
% computes the H1 norm of  u - uef
% where u is a function and uef is a finite element function
% input arguments:
% elem_vertices, vertex_coordinates:  description of the mesh
% uef:    nodal values of the finite element function
% u:      formula for the function u

n_elem = size(elem_vertices,1);

integral = 0;

for i = 1 : n_elem

  v_elem = elem_vertices(i, :);
  v1 = vertex_coordinates( v_elem(1), : )' ;
  v2 = vertex_coordinates( v_elem(2), : )' ;
  v3 = vertex_coordinates( v_elem(3), : )' ;

  % We use the cuadrature formula which uses the function values
  % at the midpoint of each side:
  % \int_T  f  \approx  |T| ( f(m12) + f(m23) + f(m31) ) / 3.
  % This formula is exact for quadratic polynomials

  % midpoints of the sides
  m12 = (v1 + v2) / 2;
  m23 = (v2 + v3) / 2;
  m31 = (v3 + v1) / 2;

  % exact values at the midpoints of the sides
  u12 = feval(u, m12);
  u23 = feval(u, m23);
  u31 = feval(u, m31);

  % finite element function at the midpoints of the sides
  uef12 = ( uef(v_elem(1)) + uef(v_elem(2)) ) / 2;
  uef23 = ( uef(v_elem(2)) + uef(v_elem(3)) ) / 2;
  uef31 = ( uef(v_elem(3)) + uef(v_elem(1)) ) / 2;

  B = [ v2-v1 , v3-v1 ];
  el_area = abs(det(B))/2;

  integral_el = ((u12 - uef12)^2 + (u23 - uef23)^2 + (u31 - uef31)^2) / 3 ...
      * el_area ;

  integral = integral + integral_el;

end

error = sqrt(integral);
