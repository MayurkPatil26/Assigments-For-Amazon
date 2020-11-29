# Assigments-For-Amazon

**Steps to Run Test cases:**
  1. Goto ```/AmazonWithLambda``` parallel run
  2. Run ```$ bundle install``` command 
  3. Run command
   * To Run Test Scenarios sequentially
   
     ```$ cucumber```    
     
   * To Run Test Scenarios in Parallel (with 2 parallels)
   
     ```$ bundle exec parallel_cucumber --type cucumber -n 2 features/ --group-by scenarios```
