
% Parámetros de la pose del robot en la terna global (G)
theta_robot_G = -pi/4;  
x_robot_G = 5;          
y_robot_G = -7;         

% Parámetros de la pose del LIDAR respecto al robot (R)
theta_lidar_R = pi;     
x_lidar_R = 0.2;        
y_lidar_R = 0;          

% Matriz de transformación del robot en la terna global
T_Global_Robot = [cos(theta_robot_G), -sin(theta_robot_G), x_robot_G;
                  sin(theta_robot_G),  cos(theta_robot_G), y_robot_G;
                  0, 0, 1];

% Matriz de transformación del LIDAR en la terna del robot
T_Robot_Lidar = [cos(theta_lidar_R), -sin(theta_lidar_R), x_lidar_R;
                 sin(theta_lidar_R),  cos(theta_lidar_R), y_lidar_R;
                 0, 0, 1];

% Posición del LIDAR en la terna global
p_lidar_G = T_Global_Robot * [x_lidar_R; y_lidar_R; 1]
x_lidar_G = p_lidar_G(1);
y_lidar_G = p_lidar_G(2);

% Matriz de transformación directa del LIDAR a la terna global
T_Global_Lidar = T_Global_Robot * T_Robot_Lidar;

% Cargar datos del LIDAR (vector de distancias)
scan = load('-ascii','laserscan.dat');  

% Calcular ángulos correspondientes a cada rayo LIDAR
angles = linspace(-pi/2, pi/2, length(scan));  

% Puntos del LIDAR en su propia terna (coordenadas homogéneas)
scan_lidar = [scan .* cos(angles); 
              scan .* sin(angles); 
              ones(1, length(scan))];  

% Transformar las mediciones a la terna global
scan_global = T_Global_Lidar * scan_lidar;

% Graficar en la terna del LIDAR
figure; hold on; axis equal;
plot(scan_lidar(1, :), scan_lidar(2, :), 'b.');
title('Mediciones en la terna del LIDAR');
xlabel('x_{lidar}');
ylabel('y_{lidar}');

% Graficar en la terna GLOBAL
figure; hold on; axis equal;
plot(scan_global(1, :), scan_global(2, :), 'b.');
plot(x_robot_G, y_robot_G, 'r+', 'MarkerSize', 10, 'LineWidth', 2); %Posicion del robot
title('Mediciones en la terna GLOBAL');
xlabel('x_{global}');
ylabel('y_{global}');
