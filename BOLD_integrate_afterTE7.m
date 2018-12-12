cd('C:\Users\jihun\Documents\MATLAB\BOLD\20181127_111701_Berbeco_Bi_Gd_1_25\T2_dynamic_crop');

for file_num = 1:495
    if rem(file_num,15) == 1
        filename = sprintf('MRIc%04d.dcm', file_num);
        delete(filename)
    end
end