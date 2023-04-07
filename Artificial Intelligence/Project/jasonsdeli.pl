/* Meat */
buys(Customer, 'roasted turkey breast') :-
    orders(Customer, 'California Club Sandwich') ;
    orders(Customer, 'Deli Club').
buys(Customer, 'bacon') :-
    orders(Customer, 'California Club Sandwich') ;
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Deli Club') ;
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'nitrite-free smoked turkey breast') :-
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'nitrite-free ham') :-
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Deli Club').
buys(Customer, 'chicken breast') :-
    orders(Customer, 'Chicken Panini') ;
    orders(Customer, 'Chipotle Chicken & Avocado Panini').


/* Cheese */
buys(Customer, 'Swiss') :-
    orders(Customer, 'California Club Sandwich') ;
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Deli Club').
buys(Customer, 'cheddar') :-
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Deli Club').
buys(Customer, 'fresh mozzarella') :-
    orders(Customer, 'Caprese Panini').
buys(Customer, 'jalapeño pepper jack') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini') ;
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'provolone') :-
    orders(Customer, 'Chicken Panini').


/* Fruit */
buys(Customer, 'tomato') :-
    orders(Customer, 'Chicken Panini') ;
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Deli Club') ;
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'Roma tomatoes') :-
    orders(Customer, 'Caprese Panini').
buys(Customer, 'sliced avocado') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini').


/* Vegetables */
buys(Customer, 'organic field greens') :-
    orders(Customer, 'California Club Sandwich').
buys(Customer, 'leafy lettuce') :-
    orders(Customer, 'Club Royale') ;
    orders(Customer, 'Deli Club').
buys(Customer, 'organic spinach') :-
    orders(Customer, 'Caprese Panini') ;
    orders(Customer, 'Chicken Panini').
buys(Customer, 'pickled red onions') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini').


/* Spreads and Sauces */
buys(Customer, 'mayo') :-
    orders(Customer, 'California Club Sandwich') ;
    orders(Customer, 'Deli Club').
buys(Customer, 'guacamole') :-
    orders(Customer, 'California Club Sandwich') ;
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'honey mustard') :-
    orders(Customer, 'Club Royale').
buys(Customer, 'pesto aioli') :-
    orders(Customer, 'Caprese Panini') ;
    orders(Customer, 'Chicken Panini').
buys(Customer, '1000 Island') :-
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'lemon crema') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini').
buys(Customer, 'chipotle aioli') :-
    orders(Customer, 'Chipotle Chicken & Avocado Panini').


/* Bread */
buys(Customer, 'toasted croissant') :-
    orders(Customer, 'California Club Sandwich') ;
    orders(Customer, 'Club Royale').
buys(Customer, 'toasted multigrain wheat') :-
    orders(Customer, 'Deli Club').
buys(Customer, 'herb focaccia') :-
    orders(Customer, 'Caprese Panini').
buys(Customer, 'sourdough') :-
    orders(Customer, 'Chicken Panini') ;
    orders(Customer, 'Smokey Jack Panini').
buys(Customer, 'pickled red onions') :-
    orders(Customer, 'Mexican-style roll').


/* Sides */
buys(Customer, side) :-
    orders(Customer, 'California Club Sandwich').


/* Put food in proper categories */
buys(Customer, 'meat') :-
    buys(Customer, 'bacon') ;
    buys(Customer, 'roasted turkey breast').
buys(Customer, 'cheese') :-
    buys(Customer, 'Swiss').
buys(Customer, 'fruit') :-
    buys(Customer, 'tomato').
buys(Customer, 'vegetables') :-
    buys(Customer, 'organic field greens').
buys(Customer, 'spread or sauce') :-
    buys(Customer, 'mayo').
buys(Customer, 'bread') :-
    buys(Customer, 'toasted croissant').

buys(Customer, 'tomato') :-
    buys(Customer, 'Roma tomatoes').

eats(A, B) :-
    buys(A, B).
    
adult(A) :- orders(A, _).
has(A, B) :- buys(A, B).
