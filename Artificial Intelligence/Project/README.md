# Steps to run this program:
1) Before executing the program, you should make sure the input is what you want. Go to input.pl and edit it to have any facts you want the knowledge base to have. For example, `orders(john, 'Chipotle Chicken & Avocado Panini', 'South Coit Road\'s Jason\'s Deli', yesterday).` states that yesterday, john orders a Chipotle Chicken & Avocado Panini at South Coit Road's Jason's Deli.
2) To execute the program, run `swipl jasonsdeli.pl input.pl`
3) Now input a fact that you want the knowledge base to prove or disprove. i.e. `?- adult(john).`