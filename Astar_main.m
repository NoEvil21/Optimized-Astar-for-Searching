Map = importdata('D:\大三上所有课程资料\机器人技术\Final Homework\打包文件\testmap.txt');

%m=20;
%n=20;
m=14;
n=14;
yinzi=0.5;
tongji=0;
Fmin=0;
ymin=0;
xmin=0;
Map_out = Map;
Path = [];
St=[2,2];
Ed=[14,3];

for i = 1:m+2
    for j = 1:n+2
        if Map(i,j)==100
            Map(i,j) = -inf;
        elseif Map(i,j)==1
            Map(i,j)=inf;
        end
    end
end

Map(St(1),St(2))=0;
Map(Ed(1),Ed(2))=inf;
G=Map;
F=Map;
openlist=Map;
closelist=Map;
px=Map;
py=Map;

openlist(St(1),St(2)) =0;
%closelist(Ed(1),Ed(2))=inf;

for i = 1:n+2
    for j = 1:m+2
        k = Map(i,j);
        if(k == -inf)
            Map_out(i,j)=500;
        elseif(k == inf)
            Map_out(i,j)=1500;
        end
    end
end
Stt=St;

iii=0;
tic
while(1)
    num=inf;
    for p=1:m+2
        for q=1:n+2
            if(openlist(p,q)==0&&closelist(p,q)~=1)
                Outpoint=[p,q];
                if(F(p,q)>=0&&num>F(p,q))
                    num=F(p,q);
                    succ=[p,q];
                end
            end
        end
    end
    closelist(succ(1),succ(2))=1;
    for i = 1:3
        for j = 1:3
            k = G(succ(1)-2+i,succ(2)-2+j);
            if((i+j==4)|(i==j)|closelist(succ(1)-2+i,succ(2)-2+j)==1)
                continue;  %遇见起点,已经过的点
            elseif (k == -inf)
                G(succ(1)-2+i,succ(2)-2+j) = G(succ(1)-2+i,succ(2)-2+j);
                closelist(succ(1)-2+i,succ(2)-2+j)=1;  %遇见障碍
            elseif (k == inf)
                distance=abs(succ(1)-2+i-2)+abs(succ(2)-2+j-2); 
                %distance=((i-2)^2+(j-2)^2)^0.5;
                G(succ(1)-2+i,succ(2)-2+j)=G(succ(1),succ(2))+distance;   %加入距离
                openlist(succ(1)-2+i,succ(2)-2+j)=0;                               %设置为待搜索节点
%————————估价函数H
                  H_diagonal=abs(succ(1)-2+i-Ed(1));
                  H_straight=abs(succ(2)-2+i-Ed(2));
                  H=H_diagonal+H_straight;
                  %H=H*(1.0+yinzi);%控制因子，防止不必要的搜索
                
                F(succ(1)-2+i,succ(2)-2+j)=G(succ(1)-2+i,succ(2)-2+j)+H;   %从起点到该处再到终点的总代价
                px(succ(1)-2+i,succ(2)-2+j)=succ(1);
                py(succ(1)-2+i,succ(2)-2+j)=succ(2);
            else
                distance=abs(succ(1)-2+i-2)+abs(succ(2)-2+i-2); %更新节点信息情况
                if(k>(distance+G(succ(1),succ(2))))
                tongji=tongji+1;
                k=distance+G(succ(1),succ(2));
%————————估价函数H
                     H_diagonal=abs(succ(1)-2+i-Ed(1));
                     H_straight=abs(succ(2)-2+i-Ed(2));
                     H=H_diagonal+H_straight;
                     H=H*(1.0+yinzi);
                

                F(succ(1)-2+i,succ(2)-2+j)=k+H;
                px(succ(1)-2+i,succ(2)-2+j)=succ(1);
                py(succ(1)-2+i,succ(2)-2+j)=succ(2);
                end    
            end
            if(((succ(1)-2+i)==Ed(1)&&(succ(2)-2+j)==Ed(2))|num==inf)
                 px(Ed(1),Ed(2))=succ(1);
                py(Ed(1),Ed(2))=succ(2);
                break;
            end
        end
        if(~((i+j==4)|(i==j))&&((succ(1)-2+i)==Ed(1)&&(succ(2)-2+j)==Ed(2))|num==inf)
             px(Ed(1),Ed(2))=succ(1);
                py(Ed(1),Ed(2))=succ(2);
            break;
        end
    %{
        if((i==3)&&(j==3))
            Fmin=F(succ(1)-1,succ(2));
            xmin=succ(1)-1;
            ymin=succ(2);
            for w=1:3
               for l=1:3
                  if ((w+l==4)|(w==l)|closelist(succ(1)-2+w,succ(2)-2+l)==1)
                      continue;
                  elseif (F(succ(1)-2+w,succ(2)-2+l)<Fmin)
                      Fmin=F(succ(1)-2+w,succ(2)-2+l);
                      xmin=succ(1)-2+w;
                      ymin=succ(2)-2+l;
                  elseif (F(succ(1)-2+w,succ(2)-2+l)==Fmin)
                      xearlier=px(succ(1),succ(2));
                      yearlier=py(succ(1),succ(2));
                      if ((abs(succ(2)-yearlier)==1)&&(abs(succ(1)-xearlier)==0))
                          if(abs(succ(1)-2+w-succ(1))==0)
                              closelist(xmin,ymin)=1;
                          else closelist(succ(1)-2+w,succ(2)-2+l)=1;
                          end
                      elseif ((abs(succ(2)-yearlier)==0)&&(abs(succ(1)-xearlier)==1))
                          if(abs(succ(2)-2+l-succ(2))==0)
                          closelist(xmin,ymin)=1;
                          else closelist(succ(1)-2+w,succ(2)-2+l)=1;
                          end
                      end    
                  end
               end
            end
        end
%}
   end
    if(~((i+j==4)|(i==j))&&((succ(1)-2+i)==Ed(1)&&(succ(2)-2+j)==Ed(2))|num==inf)
         px(Ed(1),Ed(2))=succ(1);
                py(Ed(1),Ed(2))=succ(2);
        break;
    end
end
toc
%------------------------------------------输出路径---------------------------------------------
    P=[];
    s=1;
while(1)
    if(num==inf)
        break;
    end
    iii=iii+1;
    Map_out(Ed(1),Ed(2))=iii;
    Path(iii,1)=Ed(1);
    Path(iii,2)=Ed(2);

    P(s,:)=Ed;
    s=s+1;
%      pause(1);
    xx=Ed(1);
    Ed(1)=px(Ed(1),Ed(2));
    Ed(2)=py(xx,Ed(2));
    if(px(Ed(1),Ed(2))==St(1)&&py(Ed(1),Ed(2))==St(2))
        iii=iii+1;
        Map_out(Ed(1),Ed(2))=iii;
        Path(iii,1)=Ed(1);
        Path(iii,2)=Ed(2);
        P(s,:)=Ed;
        break;
    end
end
P(s+1,:)=St;

iii=iii+1;
Map_out(Stt(1),Stt(2))=iii;
Path(iii,1)=Stt(1);
Path(iii,2)=Stt(2);

cnt=0;
for i=2:m
    for j=2:n
        if(G(i,j)~=inf&&G(i,j)~=-inf)
            cnt=cnt+1;
        end
    end
end