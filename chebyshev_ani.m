function chebyshev_ani()
    close all

    num_step = 400;
    
    L1 = 1;
    L2 = 2.5;
    L3 = 2.5;
    L4 = 2.5;
    l = 2;
    
    theta = pi/3;
    
    %%
    
    O1 = [0 0];
    
    O2 = [l 0];
    
    A = [L1*cos(theta) L1*sin(theta)];
    
    B = calculate_B(A,O2,L2,L3);
    
    C = calculate_C(A,B,L3,L4);
    
    %%

    fig = figure('Position',[200 200 500 460]);
    fig.WindowButtonDownFcn = @WBDF;
    fig.WindowButtonUpFcn = @WBUF;
    fig.KeyPressFcn = @simulatior_start_break;

    fin = 0;

    link1 = plot([O1(1) A(1)],[O1(2) A(2)],'LineWidth',5,'Color','red');
    hold on
    link2 = plot([O2(1) B(1)],[O2(2) B(2)],'LineWidth',5,'Color','blue');
    link3 = plot([A(1) C(1)],[A(2) C(2)],'LineWidth',5,'Color','green');
    
    joint = scatter([O1(1) O2(1) A(1) B(1) C(1)],[O1(2) O2(2) A(2) B(2) C(2)],40,'filled','MarkerFaceColor','k');
    
    LINEC = zeros(num_step,2);
    LINEC(1,:) = C;
    
    lineC = plot(LINEC(1,1),LINEC(1,2),'LineWidth',1,'LineStyle','-.','Color','m');

    text(1.2,7.5,'START: shift','FontSize',15,'Interpreter','none','EdgeColor','k');

    TA = text(A(1)-0.4,A(2)+0.05,'A','FontSize',15,'FontWeight','bold','Interpreter','latex');
    TB = text(B(1)-0.4,B(2)+0.05,'B','FontSize',15,'FontWeight','bold','Interpreter','latex');
    TC = text(C(1)-0.4,C(2)+0.05,'C','FontSize',15,'FontWeight','bold','Interpreter','latex');
    
    axis([-3 8 -2 8])
    xticks([])
    yticks([])
    daspect([1 1 1])
    set(gca, 'LooseInset', get(gca, 'TightInset'));
    
    %%
    
    % video = VideoWriter("chebyshev_linkage_animation.avi",'Uncompressed AVI');
    % open(video)
    
    while 1
        for i = 2:num_step
            theta = theta + (pi/100);
            A = [L1*cos(theta) L1*sin(theta)];
        
            B = calculate_B(A,O2,L2,L3);
            if isnan(B(1))
                T = text(1.2,6,'Incalculable','FontSize',20,'Interpreter','latex','Color','red');
                L1 = 1;
                L2 = 2.5;
                L3 = 2.5;
                L4 = 2.5;

                theta = pi/3;
    
                A = [L1*cos(theta) L1*sin(theta)];
            
                B = calculate_B(A,O2,L2,L3);
                
                C = calculate_C(A,B,L3,L4);
                
                set(link1,'XData',[O1(1) A(1)],'YData',[O1(2) A(2)]);
                set(link2,'XData',[O2(1) B(1)],'YData',[O2(2) B(2)]);
                set(link3,'XData',[A(1) C(1)],'YData',[A(2) C(2)]);
            
                set(joint,'XData',[O1(1) O2(1) A(1) B(1) C(1)],'YData',[O1(2) O2(2) A(2) B(2) C(2)]);
                set(lineC,'XData',LINEC(1:i,1),'YData',LINEC(1:i,2));
                set(TA,'Position',[A(1)-0.4 A(2)+0.05]);
                set(TB,'Position',[B(1)-0.4 B(2)+0.05]);
                set(TC,'Position',[C(1)-0.4 C(2)+0.05]);
                
                break
            end
            
            C = calculate_C(A,B,L3,L4);
        
            LINEC(i,:) = C;
        
            set(link1,'XData',[O1(1) A(1)],'YData',[O1(2) A(2)]);
            set(link2,'XData',[O2(1) B(1)],'YData',[O2(2) B(2)]);
            set(link3,'XData',[A(1) C(1)],'YData',[A(2) C(2)]);
        
            set(joint,'XData',[O1(1) O2(1) A(1) B(1) C(1)],'YData',[O1(2) O2(2) A(2) B(2) C(2)]);
            set(lineC,'XData',LINEC(1:i,1),'YData',LINEC(1:i,2));

            set(TA,'Position',[A(1)-0.4 A(2)+0.05]);
            set(TB,'Position',[B(1)-0.4 B(2)+0.05]);
            set(TC,'Position',[C(1)-0.4 C(2)+0.05]);
        
            % frame = getframe(gcf);
            % writeVideo(video,frame)
            drawnow
        end
        
        if exist("T","var") == 1
            pause(2)
            delete(T)
        end
        uiwait(fig)

        if fin == 1
            break
        end
    end
    % close(video)

    %%
    
    function B = calculate_B(A,O2,L2,L3)
        x1 = A(1);
        y1 = A(2);
        x2 = O2(1);
        y2 = O2(2);
        r1 = L3;
        r2 = L2;
        
        d = sqrt((x2 - x1)^2 + (y2 - y1)^2);
        a = (r1^2 - r2^2 + d^2)/(2*d);
        if r1^2 < a^2            
            B = [NaN NaN];
            return
        end
        h = sqrt(r1^2 - a^2);
    
        x0 = x1 + a*(x2 - x1)/d;
        y0 = y1 + a*(y2 - y1)/d;
    
        B = zeros(1,2);
        % B(1) = x0 + h*(y2 - y1)/d;
        % B(2) = y0 - h*(x2 - x1)/d;
    
        B(1) = x0 - h*(y2 - y1)/d;
        B(2) = y0 + h*(x2 - x1)/d;
    
    end
    %%
    
    function C = calculate_C(A,B,L3,L4)
        ft = (A(2) - B(2))/(A(1) - B(1));
    
        c1 = sqrt((L3+L4)^2 / (1 + ft^2)) * sign(B(1) - A(1));
        
        c2 = ft*c1;
        
        C = [A(1) + c1 A(2) + c2];
    end
%%
    
    function WBDF(src, ~)
        set(src, 'WindowButtonMotionFcn', @WBMF);
        function WBMF(~, ~)
            Cp = get(gca, 'CurrentPoint');
            if Cp(1, 1) < A(1) + 0.2 && Cp(1, 1) > A(1) - 0.2 && Cp(1, 2) < A(2) + 0.2 && Cp(1, 2) > A(2) - 0.2
                A(1) = Cp(1,1);
                A(2) = Cp(1,2);
            end
            if Cp(1, 1) < B(1) + 0.2 && Cp(1, 1) > B(1) - 0.2 && Cp(1, 2) < B(2) + 0.2 && Cp(1, 2) > B(2) - 0.2
                B(1) = Cp(1,1);
                B(2) = Cp(1,2);
            end
            if Cp(1, 1) < C(1) + 0.2 && Cp(1, 1) > C(1) - 0.2 && Cp(1, 2) < C(2) + 0.2 && Cp(1, 2) > C(2) - 0.2
                C(1) = Cp(1,1);
                C(2) = Cp(1,2);
            end
            L1 = norm(O1 - A);
            L2 = norm(O2 - B);
            L3 = norm(A - B);
            L4 = norm(B - C);
            A = [L1*cos(theta) L1*sin(theta)];
        
            B = calculate_B(A,O2,L2,L3);
            
            C = calculate_C(A,B,L3,L4);
            
            set(link1,'XData',[O1(1) A(1)],'YData',[O1(2) A(2)]);
            set(link2,'XData',[O2(1) B(1)],'YData',[O2(2) B(2)]);
            set(link3,'XData',[A(1) C(1)],'YData',[A(2) C(2)]);
        
            set(joint,'XData',[O1(1) O2(1) A(1) B(1) C(1)],'YData',[O1(2) O2(2) A(2) B(2) C(2)]);
            set(lineC,'XData',LINEC(1:i,1),'YData',LINEC(1:i,2));
            set(TA,'Position',[A(1)-0.4 A(2)+0.05]);
            set(TB,'Position',[B(1)-0.4 B(2)+0.05]);
            set(TC,'Position',[C(1)-0.4 C(2)+0.05]);
        end
    end

    function WBUF(src, ~)
        set(src, 'WindowButtonMotionFcn', '');
    end

    function simulatior_start_break(~, evantdata)
        if strcmp(evantdata.Key, 'escape')
            fin = 1;
        end
        if strcmp(evantdata.Key, 'shift')
            uiresume(fig);
        end
    end

end