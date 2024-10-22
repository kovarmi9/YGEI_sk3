classdef MyHuffman
    %   Cipher Sequence with Huffman Coding
    %
    %   Methods:
    %       CipherHuff    - Cipher sequence of values with Huffman codin
    %       DecipherHuff  - Decipher sequence of Huffman values
    %       ReadFiles     - Reads created files of deciphered values
    %       WriteFiles    - Writes files with ciphered values
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
                F = MyHuffman.GenerateValue(PomTable(1:2,:));
            
                nodes = {F,PomTable{1,2}+PomTable{2,2},PomTable{1,3}+PomTable{2,3}};
            
                PomTable(1:2,:)=[];
                % Creates a new table with added frequencies
                PomTable=[PomTable;nodes];
            end
            PomTable = sortrows(PomTable, 2);
            PomTable=MyHuffman.GenerateValue(PomTable(1:2,:));
            
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

        function [TableForCoding,HuffSec,Sec]=ReadFiles(ImageName,Band)
        %%
        % Read coded .txt and .csv file
        % Input: ImageName - name of image ["name"]
        %        Band      - name of band  ["_name"]
        %
        %Output: TableForCoding - coding table
        %        HuffSec        - Huffman sequnece
        %        Sec            - Deciphered Sequence
        %%
            %Declaring names fo files
            FolderName="result_";
            TableSufix="_CT";
            
            % Generating paths to results
            Folder=FolderName+ImageName;
            TableText=Folder+"/"+ImageName+Band+TableSufix+".csv";
            TableCode=Folder+"/"+ImageName+Band+TableSufix+".txt";
            SequenceText=Folder+"/"+ImageName+Band+".txt";
            
            % checks the existence of folder 
            if ~isfolder(Folder)
                error('File does not exists')
            end
            
            % Read files
            Code = string(fileread(TableCode));
            Code = strsplit(Code, ' ');
            Code=table(Code(1:end-1)');
            TableForCoding = readtable(TableText);
            TableForCoding = [TableForCoding, Code] 
            TableForCoding.Properties.VariableNames{'Var1'} ='Code';
            HuffSec = string(fileread(SequenceText));
            HuffSec = strsplit(HuffSec, ' ');
            HuffSec=HuffSec(1:end-1);
            disp("Readed files "+ImageName+Band+".txt and "+ImageName+Band+TableSufix+".csv" )
            %Decode the files into sequence
            [Sec]=MyHuffman.DecipherHuff(TableForCoding,HuffSec);
        end

        function [TableForCoding,HuffSec]=WriteFiles(ImageName,Band,HuffSec,TableForCoding)
        %%
        % Generating coded .txt and .csv file
        % Input: ImageName - name of image ["name"]
        %        Band      - name of band  ["_name"]
        %        HuffSec   - Huffman sequnece
        %        TableForCoding - coding table
        %        *If not inputet HuffSec and TableForCoding input original sequence
        %        and will create neccesary atributes*
        %
        %Output: TableForCoding - coding table
        %        HuffSec        - Huffman sequnece
        %%
            %checks number of input arguments if smaller generates Huffman
            %secquence and table
            if nargin < 4
                [TableForCoding,HuffSec]=MyHuffman.CipherHuff(HuffSec);
            end
        
            %Declaring names fo files
            FolderName="result_";
            TableSufix="_CT";
            
            % Generating paths to results
            Folder=FolderName+ImageName;
            TableText=Folder+"/"+ImageName+Band+TableSufix+".csv";
            TableCode=Folder+"/"+ImageName+Band+TableSufix+".txt";
            SequenceText=Folder+"/"+ImageName+Band+".txt";
            
            % checks the existence of folder 
            if ~isfolder(Folder)
                mkdir(Folder);
            end
            
            % Generating files
            writetable(TableForCoding(:,1:2), TableText);

            FID = fopen(TableCode, 'w');
            fprintf(FID, '%s ', TableForCoding.Code);
            fclose(FID);
        
            FID = fopen(SequenceText, 'w');
            fprintf(FID, '%s ', HuffSec);
            fclose(FID);
            disp("Generated .txt file and .csv in "+Folder)
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
           HuffSec=string(HuffSec');
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


        function F = GenerateValue(F)
            %Assingn 0|1
            F=sortrows(F,2);
            B=[F(1,:),'1'];
            E=[F(2,:),'0'];
            F=[B;E];
        end

        function [TableForCoding] = GenerateTable(CodeTable)
            % Generates Coding Table
            Value=str2double(CodeTable(:,1));
            Frequency=double(CodeTable(:,2));
            Code=CodeTable(:,3);
            TableForCoding = table(Value,Frequency,Code);
        end
    end
end