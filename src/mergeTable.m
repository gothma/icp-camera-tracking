function [result] = mergeTable(wildcard)
filenames = dir(wildcard);
for i=1:numel(filenames)
    filename = filenames(i).name;
    load(filename);
    if i > 1
        try
            x = union(x, result_table(2:end,:));
        catch
            fprintf('Error merging %s\n', filename);
        end
    else
        x = result_table(2:end,:);
    end
end
result = x;
end