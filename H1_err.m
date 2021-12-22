function error = H1_err(elem_vertices, vertex_coordinates, uef, grad_u)
% function error = H1_err(elem_vertices, vertex_coordinates, uef, grad_u)
% computes the H1 seminorm of  u - uef
% where u is a function and uef is a finite element function
% input arguments:
% elem_vertices, vertex_coordinates:  description of the mesh
% uef:    nodal values of the finite element function
% grad_u: gradient of the function u

n_elem = size(elem_vertices,1);

integral = 0;

% gradients of the basis functions in the reference element
grd_bas_fcts = [ -1 -1 ; 1 0 ; 0 1 ]' ;

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

  % exact gradient at the midpoints of the edges
  gradu12 = feval(grad_u, m12);
  gradu23 = feval(grad_u, m23);
  gradu31 = feval(grad_u, m31);

  % Computation of the gradient of the fe-function uef
  % which is constant on the element.
  % We compute it using the gradients of the basis functions
  % as in the assembly of the system

  B = [ v2-v1 , v3-v1 ];
  area_el = abs(det(B)) / 2;

  graduef = B' \ (grd_bas_fcts * uef(v_elem)) ;

  % differences at the midpoints of the sides
  dif12 = graduef - gradu12;
  dif23 = graduef - gradu23;
  dif31 = graduef - gradu31;

  integral_el = (dif12'*dif12 + dif23'*dif23 + dif31'*dif31) / 3 ...
      * area_el  ;

  integral = integral + integral_el;

end

error = sqrt(integral);
