customer(Customer, Location, Time) :-
    orders(Customer, _, Location, Time).


/* Meat */
buys(Customer, 'bacon') :-
    orders(Customer, 'California Club Sandwich', _) ;
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Deli Club', _) ;
    orders(Customer, 'Smokey Jack Panini', _).

buys(Customer, 'chicken breast') :-
    orders(Customer, 'Chicken Panini', _) ;
    orders(Customer, 'Chipotle Chicken & Avocado Panini', _).

buys(Customer, 'nitrite-free ham') :-
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Deli Club', _).

buys(Customer, 'nitrite-free smoked turkey breast') :-
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Smokey Jack Panini', _).

buys(Customer, 'roasted turkey breast') :-
    orders(Customer, 'California Club Sandwich', _) ;
    orders(Customer, 'Deli Club', _).


/* Cheese */
buys(Customer, 'cheddar') :-
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Deli Club', _).

buys(Customer, 'fresh mozzarella') :-
    orders(Customer, 'Caprese Panini', _).

buys(Customer, 'jalapeño pepper jack') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini', _) ;
    orders(Customer, 'Smokey Jack Panini', _).

buys(Customer, 'provolone') :-
    orders(Customer, 'Chicken Panini', _).

buys(Customer, 'Swiss') :-
    orders(Customer, 'California Club Sandwich', _) ;
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Deli Club', _).


/* Fruit */
buys(Customer, 'Roma tomatoes') :-
    orders(Customer, 'Caprese Panini', _).

buys(Customer, 'sliced avocado') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini', _).

buys(Customer, 'tomato') :-
    orders(Customer, 'Chicken Panini', _) ;
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Deli Club', _) ;
    orders(Customer, 'Smokey Jack Panini', _).


/* Vegetables */
buys(Customer, 'leafy lettuce') :-
    orders(Customer, 'Club Royale', _) ;
    orders(Customer, 'Deli Club', _).

buys(Customer, 'organic field greens') :-
    orders(Customer, 'California Club Sandwich', _).

buys(Customer, 'organic spinach') :-
    orders(Customer, 'Caprese Panini', _) ;
    orders(Customer, 'Chicken Panini', _).

buys(Customer, 'pickled red onions') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini', _).


/* Spreads and Sauces */
buys(Customer, '1000 Island') :-
    orders(Customer, 'Smokey Jack Panini', _).

buys(Customer, 'chipotle aioli') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini', _).

buys(Customer, 'guacamole') :-
    orders(Customer, 'California Club Sandwich', _) ;
    orders(Customer, 'Smokey Jack Panini', _).
    
buys(Customer, 'honey mustard') :-
    orders(Customer, 'Club Royale', _).

buys(Customer, 'lemon crema') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini', _).

buys(Customer, 'mayo') :-
    orders(Customer, 'California Club Sandwich', _) ;
    orders(Customer, 'Deli Club', _).

buys(Customer, 'pesto aioli') :-
    orders(Customer, 'Caprese Panini', _) ;
    orders(Customer, 'Chicken Panini', _).


/* Bread */
buys(Customer, 'herb focaccia') :-
    orders(Customer, 'Caprese Panini', _).

buys(Customer, 'pickled red onions') :-
    orders(Customer, 'Mexican-style roll', _).

buys(Customer, 'sourdough') :-
    orders(Customer, 'Chicken Panini', _) ;
    orders(Customer, 'Smokey Jack Panini', _).

buys(Customer, 'toasted croissant') :-
    orders(Customer, 'California Club Sandwich', _) ;
    orders(Customer, 'Club Royale', _).

buys(Customer, 'toasted multigrain wheat') :-
    orders(Customer, 'Deli Club', _).


/* Sides */
buys(Customer, side) :-
    orders(Customer, 'California Club Sandwich', _).


/* Put food in proper categories */
buys(Customer, 'meat') :-
    buys(Customer, 'bacon') ;
    buys(Customer, 'chicken breast') ;
    buys(Customer, 'roasted turkey breast') ;
    buys(Customer, 'nitrite-free ham') ;
    buys(Customer, 'nitrite-free smoked turkey breast').

buys(Customer, 'cheese') :-
    buys(Customer, 'cheddar') ;
    buys(Customer, 'fresh mozzarella') ;
    buys(Customer, 'jalapeño pepper jack') ;
    buys(Customer, 'provolone') ;
    buys(Customer, 'Swiss').

buys(Customer, 'fruit') :-
    buys(Customer, 'Roma tomatoes') ;
    buys(Customer, 'sliced avocado') ;
    buys(Customer, 'tomato').

buys(Customer, 'vegetables') :-
    buys(Customer, 'leafy lettuce') ;
    buys(Customer, 'organic field greens') ;
    buys(Customer, 'organic spinach') ;
    buys(Customer, 'pickled red onions').

buys(Customer, 'spread or sauce') :-
    buys(Customer, '1000 Island') ;
    buys(Customer, 'chipotle aioli') ;
    buys(Customer, 'guacamole') ;
    buys(Customer, 'honey mustard') ;
    buys(Customer, 'lemon crema') ;
    buys(Customer, 'mayo') ;
    buys(Customer, 'pesto aioli').
    
buys(Customer, 'bread') :-
    buys(Customer, 'herb focaccia') ;
    buys(Customer, 'pickled red onions') ;
    buys(Customer, 'sourdough') ;
    buys(Customer, 'toasted croissant') ;
    buys(Customer, 'toasted multigrain wheat').

buys(Customer, 'tomato') :-
    buys(Customer, 'Roma tomatoes').

/* Q1 */
adult(A) :- orders(A, _).

/* Q2 */
eats(Person, Food) :-
    buys(Person, Food).

/* Q4 */
spends(Customer, money, Location) :- orders(Customer, _, Location).

brings(Customer, money ; creditcard, Location) :-
    spends(Customer, money, Location).

/* Q5 */
subevent(at(Customer, Location), Event) :-
    customer(Customer, Location, Event).
subevent(orders(Customer, Item, Location), at(Customer, Location)) :-
    orders(Customer, Item, Location).

/* Sub events are transitive */
subevent(A, C) :-
    subevent(A, B),
    subevent(B, C).

/* If A is true after B, then A is also true after all of B's parent events. */    
after(A, C) :-
    after(A, B),
    subevent(B, C).

after(hasless(Customer, money), orders(Customer, _, _)) :-
    orders(Customer, _, _).

/* The customer leaves after they arrive. 
after(leaves(Customer, Location), arrives(Customer, Location)) :-
    customer(Customer, Location, _).
*/
/* 
The customer:
    orders after they arrive
    has less money after they order
    leaves after they spend money
after(orders(Customer, Item, Location), arrives(Customer, Location)) :-
    orders(Customer, Item, Location).
after(hasless(Customer, money), orders(Customer, Item, Location)) :-
    orders(Customer, Item, Location).
after(leaves(Customer, Location), hasless(Customer, money)) :-
    orders(Customer, _, Location).

after(X, Z) :- after(X, Y), after(Y, Z).
before(A, B) :- after(B, A).

during(arrives(Customer, Location), Time) :-
    customer(Customer, Location, Time).
during(leaves(Customer, Location), Time) :-
    customer(Customer, Location, Time).
*/

/* Q6 */
at(Location, staff, Time) :-
    orders(_, Location, Time).

/* Q7 */
vegetarian(Customer) :-
    eats(Customer, _),
    \+ (
        eats(Customer, Food),
        Food = 'meat'
    ).

/* Q8 */
buys(Customer, ounce('roast beef')) :-
    buys(Customer, 'roast beef').
has(A, B) :- buys(A, B).

/* Q9 */
