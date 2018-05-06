library(keras)

df = dataset_boston_housing()

#train = data.frame(df$train$x,medv = df$train$y)

#train_scale = scale(train)

train_x = normalize(df$train$x)
train_y = t(normalize(df$train$y))
test_x = normalize(df$test$x)
test_y = t(normalize(df$test$y))


model <- keras_model_sequential() 

model %>% layer_dense(units = 8, activation = 'relu', input_shape = c(13)) %>% 
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 1)

model %>% compile(loss='mse',optimizer='rmsprop',metrics='mae')

history = model %>% fit(train_x,train_y, epochs=1,batch_size = 8,validation_split = 0.2)


summary(model)
