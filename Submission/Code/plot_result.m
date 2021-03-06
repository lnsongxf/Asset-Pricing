function plot_result(t_lambda, lambda, alpha, beta, gamma, covariance, excess_returns, dates)
    % Plots the residual 
    figure
    predicted_returns = (beta*gamma)';
    actual_returns = excess_returns;
    residual = predicted_returns - actual_returns;
    xDates = date_conversion(dates);
    plot(xDates, residual, '.')
    datetick('x','yyyy-mm')
    xlim([xDates(1) xDates(end)])
    ylabel('Residual','FontSize',14)
    grid on 
    
end