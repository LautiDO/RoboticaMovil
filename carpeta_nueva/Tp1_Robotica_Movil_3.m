% Parámetros iniciales
x = 0; y = 0; theta = pi/4;
l = 0.5;
dt = 0.1; % paso de simulación más pequeño

% Secuencia de acciones: [v_l, v_r, t]
acciones = [
    0.1  0.5  2;
    0.5  0.1  2;
    0.2  0.2  2;
    1.0  0.0  4;
    0.4  0.4  2;
    0.2 -0.2  2;
    0.5  0.5  2
];

% Almacenar trayectoria
trayectoria = [x; y];

% Ejecutar cada acción en pasos de dt
for i = 1:size(acciones, 1)
    v_l = acciones(i,1);
    v_r = acciones(i,2);
    t_total = acciones(i,3);
    
    % Dividir la acción en pequeños pasos de tiempo
    for t = 0:dt:(t_total-dt)
        [x, y, theta] = diffdrive(x, y, theta, v_l, v_r, dt, l);
        trayectoria(:, end+1) = [x; y];
    end
end

% Graficar trayectoria
figure; hold on; axis equal;
plot(trayectoria(1,:), trayectoria(2,:), 'b-');
plot(trayectoria(1,1), trayectoria(2,1), 'go', 'MarkerSize', 8, 'DisplayName', 'Inicio');
plot(trayectoria(1,end), trayectoria(2,end), 'ro', 'MarkerSize', 8, 'DisplayName', 'Fin');
xlabel('x [m]'); ylabel('y [m]');
title('Trayectoria del robot diferencial');
legend;

function [x_n, y_n, theta_n] = diffdrive(x, y, theta, v_l, v_r, t, l)
    % Cálculo de velocidades en la terna del robot
    v = (1/2)*(v_l + v_r);          % Velocidad lineal del robot
    w = (1/l)*(v_r - v_l);          % Velocidad angular del robot

    % Vector de velocidades en la terna del robot
    v_robot = [v; 0; w];

    % Matriz de transformación del robot a la terna global
    T_Global_Robot = [cos(theta), -sin(theta), 0;
                      sin(theta),  cos(theta), 0;
                      0,           0,          1];

    % Velocidad en la terna global
    v_global = T_Global_Robot * v_robot;

    % Nueva pose luego de aplicar durante t segundos
    x_n = x + v_global(1) * t;
    y_n = y + v_global(2) * t;
    theta_n = theta + v_global(3) * t;
end
