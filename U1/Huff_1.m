clc; clear; format long G

Sec=randi(5,1,20,1)-1;

Sec=[0,0,0,0,0,1,1,1,1,1,2,2,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,6,6];

Table={Sec(1),1};

%Count the frequency of parametrs
for i=2:length(Sec)
    if any([Table{:,1}]==Sec(i))
        for j=1:size(Table,1)
            if Table{j,1}==Sec(i)
                Table{j,2}=Table{j,2}+1;
            end
        end
    else
        Table=[Table;{Sec(i),1}];
    end
end

%sorting table by the frequency
Table = sortrows(Table, 2);

nodes = {Table(1:2,:),Table{1,2}+Table{1,2}};
Nodes  = {Table(end-1:end,:),Table{end-1,2}+Table{end,2}}
Table(1:2,:)=[];
Table(end-1:end,:)=[];
Table=[Table;Nodes;nodes];

