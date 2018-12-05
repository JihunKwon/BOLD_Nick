function integrate_files(base_name,animal_name,time_name)
%integrate_files This function copy files for dynamic T2*w scan and move to
%the new folder named "T2_dynamic"

cd(base_name)
mkdir T2_dynamic

if strcmp(animal_name,'M4')
    if strcmp(time_name,'PreRT')
        target_dir = [17 18 19 20 21 23 26 28 29 30 31];
    elseif strcmp(time_name,'PostRT')
        target_dir = [8 9 11 12 13 14 15 16 17 18 20];
    end
else
    print('No such animal!!')
end

for tp = 1:size(target_dir,2)
    tp_string = target_dir(tp);
    tp_string = num2str(tp_string);
    cd(tp_string)
    
    cd pdata\1\dicom\
    
    %This part change file name. Four digits.
    for file_num = 1:45
        file_old = sprintf('MRIm%02d.dcm', file_num);
        file_new = sprintf('MRIm%04d.dcm', file_num+(tp-1)*45);
        movefile(file_old,file_new);
    end
    
    %This part copy files to one folder.
    src = pwd;
    dest = strcat(base_name,'\T2_dynamic');
    easycopy(src,dest);
    cd ..\..\..\..
end
end

