/* Meat */
buys(Customer, 'bacon') :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich', 'Club Royale', 'Deli Club', 'Smokey Jack Panini']).

buys(Customer, 'chicken breast') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chicken Panini', 'Chicken Tenders', 'Chipotle Chicken & Avocado Panini']).

buys(Customer, 'corned beef') :-
    orders(Customer, Item, _, _),
    member(Item, ['New York Yankee']).

buys(Customer, 'nitrite-free ham') :-
    orders(Customer, Item, _, _),
    member(Item, ['Club Royale', 'Deli Club']).

buys(Customer, 'nitrite-free smoked turkey breast') :-
    orders(Customer, Item, _, _),
    member(Item, ['Club Royale', 'Smokey Jack Panini']).

buys(Customer, 'pastrami') :-
    orders(Customer, Item, _, _),
    member(Item, ['New York Yankee']).

buys(Customer, 'roasted turkey breast') :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich', 'Deli Club']).

buys(Customer, 'roast beef') :-
    orders(Customer, Item, _, _),
    member(Item, ['Beefeater']).

buys(Customer, 'Wild Alaska sockeye salmon') :-
    orders(Customer, Item, _, _),
    member(Item, ['Wild Salmon-wich']).


/* Cheese */
buys(Customer, 'cheddar') :-
    orders(Customer, Item, _, _),
    member(Item, ['Club Royale', 'Deli Club', 'Grilled Cheese']).

buys(Customer, 'fresh mozzarella') :-
    orders(Customer, Item, _, _),
    member(Item, ['Caprese Panini']).

buys(Customer, 'jalapeño pepper jack') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chipotle Chicken & Avocado Panini', 'Smokey Jack Panini']).

buys(Customer, 'provolone') :-
    orders(Customer, Item, _, _),
    member(Item, ['Beefeater', 'Chicken Panini']).

buys(Customer, 'Swiss') :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich', 'Club Royale', 'Deli Club', 'New York Yankee']).


/* Fruit */
buys(Customer, 'Roma tomatoes') :-
    orders(Customer, Item, _, _),
    member(Item, ['Caprese Panini']).

buys(Customer, 'sliced avocado') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chipotle Chicken & Avocado Panini']).

buys(Customer, 'tomato') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chicken Panini', 'Club Royale', 'Deli Club', 'Smokey Jack Panini', 'Wild Salmon-wich']).


/* Vegetables */
buys(Customer, 'leafy lettuce') :-
    orders(Customer, Item, _, _),
    member(Item, ['Club Royale', 'Deli Club', 'Wild Salmon-wich']).

buys(Customer, 'organic field greens') :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich']).

buys(Customer, 'organic spinach') :-
    orders(Customer, Item, _, _),
    member(Item, ['Caprese Panini', 'Chicken Panini']).

buys(Customer, 'pickled red onions') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chipotle Chicken & Avocado Panini']).


/* Spreads and Sauces */
buys(Customer, '1000 Island') :-
    orders(Customer, Item, _, _),
    member(Item, ['Smokey Jack Panini']).

buys(Customer, 'balsamic vinaigrette') :-
    orders(Customer, Item, _, _),
    member(Item, ['Wild Salmon-wich']).

buys(Customer, 'chipotle aioli') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chipotle Chicken & Avocado Panini', 'Wild Salmon-wich']).

buys(Customer, 'guacamole') :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich', 'Smokey Jack Panini', 'Wild Salmon-wich']).
    
buys(Customer, 'honey mustard') :-
    orders(Customer, Item, _, _),
    member(Item, ['Club Royale']).

buys(Customer, 'lemon crema') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chipotle Chicken & Avocado Panini']).

buys(Customer, 'mayo') :-
    orders(Customer, Item, _, _),
    member(Item, ['Beefeater', 'California Club Sandwich', 'Deli Club']).

buys(Customer, 'pesto aioli') :-
    orders(Customer, Item, _, _),
    member(Item, ['Caprese Panini', 'Chicken Panini']).


/* Bread */
buys(Customer, 'croissant') :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich', 'Club Royale']).

buys(Customer, 'herb focaccia') :-
    orders(Customer, Item, _, _),
    member(Item, ['Caprese Panini', 'Wild Salmon-wich']).

buys(Customer, 'Marbled Rye') :-
    orders(Customer, Item, _, _),
    member(Item, ['New York Yankee']).

buys(Customer, 'Mexican-style roll') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chipotle Chicken & Avocado Panini']).

buys(Customer, 'multigrain wheat') :-
    orders(Customer, Item, _, _),
    member(Item, ['Deli Club', 'Grilled Cheese']).

buys(Customer, 'New Orleans French') :-
    orders(Customer, Item, _, _),
    member(Item, ['Beefeater']).

buys(Customer, 'sourdough') :-
    orders(Customer, Item, _, _),
    member(Item, ['Chicken Panini', 'Smokey Jack Panini']).


/* Sides */
buys(Customer, side) :-
    orders(Customer, Item, _, _),
    member(Item, ['California Club Sandwich', 'Wild Salmon-wich']).
    
buys(Customer, 'cup of au jus') :-
    orders(Customer, Item, _, _),
    member(Item, ['Beefeater']).


/* Put food in proper categories */
meat(Food) :-
    member(Food, ['bacon', 'chicken breast', 'corned beef', 'nitrite-free ham', 'nitrite-free smoked turkey breast', 'pastrami', 'roast beef', 'roasted turkey breast']).

fish(Food) :-
    member(Food, ['Wild Alaska sockeye salmon']).

cheese(Food) :-
    member(Food, ['cheddar', 'fresh mozzarella', 'jalapeño pepper jack', 'provolone', 'Swiss']).

tomato(Food) :-
    member(Food, ['Roma tomatoes', 'tomato']).

fruit(Food) :-
    Food = 'sliced avocado' ;
    tomato(Food).

vegetables(Food) :-
    member(Food, ['leafy lettuce', 'organic field greens', 'organic spinach', 'pickled red onions']).

spreadorsauce(Food) :-
    member(Food, ['1000 Island', 'balsamic vinaigrette', 'chipotle aioli', 'guacamole', 'honey mustard', 'lemon crema', 'mayo', 'pesto aioli']).
    
bread(Food) :-
    member(Food, ['croissant', 'herb focaccia', 'Marbled Rye', 'Mexican-style roll', 'multigrain wheat', 'New Orleans French', 'sourdough']).

toasted(Food) :-
    member(Food, ['croissant', 'herb focaccia', 'Marbled Rye', 'multigrain wheat', 'New Orleans French']).

food(Food) :-
    meat(Food) ;
    fish(Food) ;
    cheese(Food) ;
    fruit(Food) ;
    vegetables(Food) ;
    spreadorsauce(Food) ;
    bread(Food) ;
    tomato(Food).


/* Did the customer have toasted bread? */
hadToastedBread(Customer) :-
    eats(Customer, Food),
    bread(Food),
    toasted(Food).

calories('California Club Sandwich', 690).
calories('Club Royale', 680).
calories('Deli Club', 800).
calories('Caprese Panini', 740).
calories('Smokey Jack Panini', 770).
calories('Chicken Panini', 770).
calories('Chipotle Chicken & Avocado Panini', 930).
calories('Beefeater', 840).
calories('Wild Salmon-wich', 600).
calories('New York Yankee', 1100).
calories('Grilled Cheese', 450).
calories('Chicken Tenders', 240).

milesToBurnOffMeal(Person, Miles, Time) :-
    orders(Person, Meal, _, Time),
    calories(Meal, Calories),
    Miles is (Calories / 100).

costs('California Club Sandwich', 10.69).
costs('Club Royale', 10.69).
costs('Deli Club', 10.69).
costs('Caprese Panini', 9.19).
costs('Smokey Jack Panini', 10.39).
costs('Chicken Panini', 10.29).
costs('Chipotle Chicken & Avocado Panini', 10.29).
costs('Beefeater', 11.79).
costs('Wild Salmon-wich', 12.39).
costs('New York Yankee', 14.39).
costs('Grilled Cheese', 4.29).
costs('Chicken Tenders', 5.19).

/*
What was the most expensive order a customer placed in a certain time period?
*/
mostExpensive(Customer, Item, Price, Time):-
    costs(Item,Price),
    orders(Customer, Item, _, Time),
    forall(( orders(Customer, X, _, Time), costs(X,Y) ),(Y>Price->fail;true)).

opens('South Coit Road\'s Jason\'s Deli', 1000).
closes('South Coit Road\'s Jason\'s Deli', 2200).

between(Time, range(Start, End)) :-
    Time >= Start,
    Time < End.

waitRange('South Coit Road\'s Jason\'s Deli', 10, TimeRange) :-
    member(TimeRange, [range(1000, 1200), range(1400, 1600), range(2000, 2200)]).
waitRange('South Coit Road\'s Jason\'s Deli', 20, TimeRange) :-
    member(TimeRange, [range(1200, 1400), range(1600, 1800)]).
waitRange('South Coit Road\'s Jason\'s Deli', 30, TimeRange) :-
    member(TimeRange, [range(1800, 2000)]).
/* How long is the wait time at Time? */
waitTime(Location, Wait, Time) :-
    waitRange(Location, Wait, range(Start, End)),
    between(Time, range(Start, End)).

/*
How many orders were placed by a specific customer?
How many orders were placed in a certain time period?
How many orders were placed by a specific customer in a certain time period?
*/
totalOrders(Customer, Time, Count) :-
    aggregate_all(count, orders(Customer, _, _, Time), Count).

/*
How much money was spent by a specific customer?
How much money was spent in a certain time period?
How much money was spent by a specific customer in a certain time period?
*/
totalSpent(Customer, Time, Cost) :-
    aggregate_all(sum(Cost), (orders(Customer, Item, _, Time), costs(Item, Cost)), Cost).


/* Q1 */
/* Customer is an adult if Customer places an order */
child(Customer) :-
    orders(Customer, _, _, _),
    \+ (
        orders(Customer, Meal, _, _),
        (
            Meal \= 'Grilled Cheese',
            Meal \= 'Chicken Tenders'
        )
    ).
adult(Customer) :-
    orders(Customer, _, _, _),
    \+ child(Customer).
person(Customer) :- orders(Customer, _, _, _).

/* Q2
    Already mostly answered this one by categorizing food but
    need to clarify that the person eats any food they buy
*/
eats(Person, Food) :-
    buys(Person, Food),
    food(Food).

/* Q4 */
/* If the customer buys something then they must have brought money or a credit card to pay for it */
brings(Customer, Money, Location) :-
    orders(Customer, _, Location, _),
    member(Money, ['cash', 'credit card']).

/* Q5 */
/*
    The customer must have ordered while at the location
    The customer has less money after they order
    Therefore, they must also have less money after leaving the location
*/
subevent(orders(Customer, Item, Location, Time), at(Customer, Location, Time)) :-
    orders(Customer, Item, Location, Time).
after(hasless(Customer, money), orders(Customer, _, _, _)) :-
    orders(Customer, _, _, _).

after(A, C) :-
    subevent(B, C),
    after(A, B).

/* Q6 */
/* If someone orders from a location at a certain time then there must be staff there to prepare the order */
people(staff).
at(staff, Location, Time) :-
    orders(_, _, Location, Time).
at(Customer, Location, Time) :-
    orders(Customer, _, Location, Time).

/* Q7 */
vegetarian(Customer) :-
    eats(Customer, _),
    \+ (
        eats(Customer, Food),
        (
            meat(Food) ;
            fish(Food)
        )
    ).

pescetarian(Customer) :-
    eats(Customer, _),
    \+ (
        eats(Customer, Food),
        meat(Food)
    ).

/* Q8 */
eats(Customer, ounce('roast beef')) :-
    eats(Customer, 'roast beef').
have(Customer, Food) :- eats(Customer, Food).
