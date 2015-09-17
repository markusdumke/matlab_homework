X = [1 2 3; 4 5 6; 7 8 9]

Y = X(1:size(X,1),flip(1:size(X,2)))
sum(diag(Y))



%%
x = '100000001111110111010101010'
x_as_vector = x-'0'
y = x_as_vector

for ii=2:length(x_as_vector)
   if x_as_vector(ii) == 1
       y(ii) = y(ii-1) + x_as_vector(ii);
   else
       y(ii) = 0;
   end
end

y = max(y)
%%
x = [0 0 1 2 3]

[val, ind] = sort(x)
if length(unique(x)) == length(x) 

test = ind == 1:length(x)
tf = min(test)

else
   tf = 0 
end



%%
x = [5 0 -3 0 -3 11 -3 5 5 0]
x = [0 0 ];

numbersinx = unique(x)
y = zeros(1,length(numbersinx))

for ii=1:length(numbersinx)
    y(ii) = sum(x == numbersinx(ii))
end

numbersinx(y==3)
 






