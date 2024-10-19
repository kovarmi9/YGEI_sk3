classdef MyHuffman
    %   Cipher Sequence with Huffman Coding
    %
    %   Methods:
    %       CipherHuff    - Cipher sequence of values with Huffman codin
    %       DecipherHuff  - Decipher sequence of Huffman values

    methods (Static)
        function [TableForCoding,HuffSec] = CipherHuff(Sec)
            %% Cipher sequence with Huffman Coding
            % Input - Sec - Sequence of numbers
            % Output- HuffSec - Sequence of numbers coded with HUúffman
            %                   coding
            %       - TableForCoding - Table of |Values|Frequency|Code|
            %
            %%
            Table={Sec(1),1,1};

            %Count the frequency of parametrs
            for i=2:length(Sec)
                % Check if any number of the Sequention is in the 
                if any([Table{:,1}]==Sec(i))
                    % If YES find its value and add count
                    for j=1:size(Table,1)
                        % Checks the value
                        if Table{j,1}==Sec(i)
                            % Add Count
                            Table{j,2}=Table{j,2}+1;
                        end
                    end
                else
                    % If NO Creates row for new value
                    Table=[Table;{Sec(i),1,1}];
                end
            end
            
            % Sorts Value
            Table=sortrows(Table, 2);
            % Creates a helping Table
            PomTable=Table;
            
            % Creates a Huffman Tree
            while  size(PomTable,1)>2
                %sorting table by the frequency
                PomTable = sortrows(PomTable, 2);
                % Pick the two smallest and add the frequency
                nodes = {PomTable(1:2,:),PomTable{1,2}+PomTable{2,2},PomTable{1,3}+PomTable{2,3}};
                PomTable(1:2,:)=[];
                % Creates a new table with added frequencies
                PomTable=[PomTable;nodes];
            end
            PomTable = MyHuffman.AssignValues(PomTable);
            
            
            CodeTable=[];
            [CodeTable] = MyHuffman.CipherValues(PomTable,CodeTable,"");
            
            TableForCoding = MyHuffman.GenerateTable(CodeTable);
            
            
            HuffSec = MyHuffman.CipherSec(TableForCoding,Sec);
        end

        function Sec = DecipherHuff(TableForCoding,HuffSec)
            %% Decipher Huffman sequence 
            % Input - TableForCoding - Table of |Values|Frequency|Code|
            %       - HuffSec        - Huffman sequence
            % Output- Sec - Sequence of deciphered numbers
            %
            %%
            %Creates an empty array of the same size as a imput array
            Sec=zeros(length(HuffSec),1);
            Sec=Sec';
            % runs for each number in sequention
            for i=1:length(HuffSec)
                % runs for each unique value
                for j=1:size(TableForCoding,1)
                    % check the value of CodingTable and input Sequence
                    if HuffSec(i) == TableForCoding.Code(j)
                        % Add coresponding Code to the emtpy array
                        Sec(i) = TableForCoding.Value(j);
                    end
                end
            end
        end
    end

    methods (Static, Access = private)
        function [S,Code] = CipherValues(F,S,Code)
            %Goes for each level
            for i=1:2
                % Checks if its on the bottom
                % If not
                if F{i,3}~=1 
                    % Add 0|1
                    Code=Code+F{i,4};
                    % Goes one level down
                    [S,Code] = MyHuffman.CipherValues(F{i,1},S,Code);
                else
                    % Adds 0|1
                    Code=Code+F{i,4};
                    % Creates array of Value, Frequency and Code 
                    S=[S;F{i,1},F{i,2},Code];
                    % Removes last code when going up
                    Code=char(Code);
                    Code=Code(1:end-1);
                    Code=string(Code);
                end
            end
            % Removes last code when going up
            Code=char(Code);
            Code=Code(1:end-1);
            Code=string(Code);
        end

        function HuffSec = CipherSec(TableForCoding,Sec)
           %Creates an empty array of the same size as a imput array
           HuffSec=zeros(length(Sec),1);
           HuffSec=HuffSec';
           % runs for each number in sequention
           for i=1:length(Sec)
               % runs for each unique value
               for j=1:size(TableForCoding,1)
                   % check the value of CodingTable and input Sequence
                   if Sec(i) == TableForCoding.Value(j)
                       % Add coresponding Code to the emtpy array
                       HuffSec(i) = TableForCoding.Code(j);
                   end
               end
           end
        end

        function F = AssignValues(F)
            % Generates value 0|1 for each leaf
            F = MyHuffman.GenerateValue(F);
            % Goes for two leafs
            for i=1:2
                % Checks number of leafs
                if F{i,3}~=1
                    % if is not in the bottom goes one level down
                    F{i,1} = MyHuffman.AssignValues(F{i,1});
                end
            end
        end

        function F = GenerateValue(F)
            %Assingn 0|1
            if (F{1,3}~=1 || F{2,3}~=1) && abs(F{1,3}-F{2,3})/abs(F{1,2}-F{2,2})>=(F{1,3}+F{2,3})/(F{1,2}+F{2,2})
                % Checks number of leafs and if ratio od differences is greater
                % than ration fo sum
                % Sort value primarly on the number of leafs
                F=sortrows(sortrows(F, 2), 3);
                % Assign value of 0|1
                B=[F(1,:),'0']; 
                E=[F(2,:),'1'];
            else
                % If its on a bottom Sort primarly sortin on frequency
                F=sortrows(F,2);
                % Assign value of 0|1
                B=[F(1,:),'1'];
                E=[F(2,:),'0'];
            end
            F=[B;E];
        end

        function [TableForCoding] = GenerateTable(CodeTable)
            % How many values are used
            n=size(CodeTable,1);
            % Creates an empty arrays
            Value=zeros(n,1);
            Frequency=zeros(n,1);
            Code=zeros(n,1);
            % Fill Empty arrays
            for i=1:n
                code=char(CodeTable(i,3));
                % Checking if Code beggins with 0
                if code(1)==0
                    % Reduce beginig zero
                    code=code(2:end);
                end
                Code(i)=string(code);
                Value(i) = str2double(CodeTable(i,1));
                Frequency(i) = CodeTable(i,2);
            end
            % Generate table
            TableForCoding = table(Value,Frequency,Code);
        end
    end
end