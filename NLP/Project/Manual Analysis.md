Sentence ID: 8007
Sentence: "A child is told a <e1>lie</e1> for several years by their <e2>parents</e2> before he/she realizes that a Santa Claus does not exist."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: The system might be interpreting lie as an action the child takes by their parents. In that case, the relation wouldn't fit with any of the labels we're using, so it becomes Other.

Sentence ID: 8008
Sentence: "Skype, a free software, allows a <e1>hookup</e1> of multiple computer <e2>users</e2> to join in an online conference call without incurring any telephone costs."
Predicted: Instrument-Agency(e2,e1)
True label: Other
Analysis: The system probably assumes that typically, when a user takes actions related to computers, they are using the computer-related item as an instrument.

Sentence ID: 8009
Sentence: "The disgusting scene was retaliation against her brother Philip who rents the <e1>room</e1> inside this apartment <e2>house</e2> on Lombard street."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: The system probably assumes the room is inside the apartment and the house is related in some other way.

Sentence ID: 8012
Sentence: "On a friend's advice, I purchased a sauerkraut and <e1>kimchi</e1> <e2>maker</e2> here and it is just fabulous (and cheap too)."
Predicted: Product-Producer(e1,e2)
True label: Other
Analysis: In this case, the user makes the kimchi, not the maker. The system obviously thinks the maker is making the kimchi which makes sense on first glance.

Sentence ID: 8014
Sentence: "As a <e1>landscape</e1> <e2>company</e2> in Atlanta, we know which plants thrive in this planting zone and know the optimum landscaping designs for local yards and business."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: Landscape is both a description of the company and a product that the company produces. The system probably can't parse which one it should be interpreting landscape as.

Sentence ID: 8018
Sentence: "An FTP server is an inexpensive and relatively simple to operate tool that works great for <e1>filesharing</e1> over the <e2>internet</e2>."
Predicted: Product-Producer(e2,e1)
True label: Other
Analysis: This one is probably because Purpose-Tool and Product-Producer are quite similar but we did not train on any Purpose-Tool relationships so it gets marked as Product-Producer.

Sentence ID: 8023
Sentence: "I spent a year working for a <e1>software</e1> <e2>company</e2> to pay off my college loans."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: Same as 8014. Software is both a description of the company and a product that the company produces. The system probably can't parse which one it should be interpreting software as.

Sentence ID: 8024
Sentence: "The <e1>captain</e1> and the <e2>crew</e2> of the Steve Irwin are grateful for the support of the City of Fremantle and Mayor Brad Pettitt for hosting the event."
Predicted: Component-Whole(e1,e2)
True label: Other
Analysis: While a captain is a component of a crew, in this case the captain is being referred to separately from the crew. The system couldn't make that distinction though.

Sentence ID: 8026
Sentence: "Mileson has sold his humble abode to a <e1>housing</e1> <e2>developer</e2>."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: Same problem as 8014. Housing is both a description of the developer and a product that the developer produces. The system probably can't parse which one it should be interpreting housing as.

Sentence ID: 8027
Sentence: "The same <e1>effect</e1> is achieved the traditional <e2>way</e2>, with a team of workers like Keebler elves."
Predicted: Instrument-Agency(e2,e1)
True label: Cause-Effect(e2,e1)
Analysis: The system might be interpreting 'team of workers' to imply that an instrument is being used since it's more often that workers use instruments than they have causes and effects.

Sentence ID: 8034
Sentence: "Essentially, the <e1>blisters</e1> that appear in the mouth are caused by the <e2>herpes simplex virus</e2> type 1, HSV-1 for short."
Predicted: Component-Whole(e2,e1)
True label: Product-Producer(e1,e2)
Analysis: The system is probably having trouble deciphering what is related to what given how many relations are spelled out in such few words: 'blisters that appear in the mouth are caused by the herpes simplex virus'.

Sentence ID: 8035
Sentence: "The man at the helm was watching the <e1>luff</e1> of the <e2>sail</e2> and whistling away gently to himself, and that was the only sound excepting the swish of the sea."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: The system doesn't have enough training to know that a luff is a component of a sail.

Sentence ID: 8040
Sentence: "<e1>Roundworms</e1> or ascarids are caused by an intestinal <e2>parasite</e2> called Toxocara canis."
Predicted: Cause-Effect(e2,e1)
True label: Product-Producer(e1,e2)
Analysis: The sentence says that roundworms are caused by parasites. Additional knowledge (that the system doesn't have) would be required to understand that parasites produce roundworms.

Sentence ID: 8042
Sentence: "My <e1>cat</e1> has a problem with his <e2>paw</e2>."
Predicted: Other
True label: Component-Whole(e2,e1)
Analysis: The system doesn't have enough training information to know that paws are components of cats.

Sentence ID: 8043
Sentence: "The <e1>treaty</e1> establishes a double majority <e2>rule</e2> for Council decisions."
Predicted: Other
True label: Cause-Effect(e1,e2)
Analysis: The system might not know how to interpret rule. Is it a regulation or an authority?

Sentence ID: 8047
Sentence: "By dividing the <e1>space</e1> in a kitchen <e2>drawer</e2> where you keep all your cooking utensils, you grouped items by size or purpose."
Predicted: Component-Whole(e2,e1)
True label: Other
Analysis: The system probably thinks that space is typically the whole that is occupied by some component. However, in this scenario, the relation between space and drawer cannot be ascertained as space is too ambiguous.

Sentence ID: 8051
Sentence: "As Vinay collapsed in pain, the villagers poured <e1>acid</e1> into his <e2>eyes</e2>."
Predicted: Cause-Effect(e1,e2)
True label: Other
Analysis: The system might recognize pain and poured as words. that are typically used in Cause-Effect relationships.

Sentence ID: 8055
Sentence: "In South Africa, which has one of the best police to public ratios on the continent, the share of <e1>murders</e1> that result in a <e2>conviction</e2> is about 18%, compared to 56% in the US and 61% in the UK."
Predicted: Cause-Effect(e2,e1)
True label: Cause-Effect(e1,e2)
Analysis: The system recognizes the Cause-Effect but might be interpreting the sentence to be 'murders that result from a conviction' rather than 'in a conviction'.

Sentence ID: 8062
Sentence: "The text also exists in a <e1>transcript</e1> by a professional <e2>scribe</e2>, which was prepared for Sir Dudley Carleton."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: The system probably doesn't have enough data to recognize that scribes produce scripts and instead thinks the transcript might be an instrument of the scribe or was caused by the scribe.

Sentence ID: 8064
Sentence: "The <e1>committee</e1> is an integral part of our <e2>organisation</e2>."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: The system is probably confused by 'integral'. It might think that the committee is an integral and that integral is part of the organisation.

Sentence ID: 8066
Sentence: "The <e1>family</e1> constructed some TCU Horned Frog supporting snow <e2>features</e2> as well as just a really nice picture of an old fashioned light post."
Predicted: Component-Whole(e2,e1)
True label: Product-Producer(e2,e1)
Analysis: It's likely that in training, family was only used in relation to components of family like mom, dad, son, daughter, etc. This might have resulted in overfitting where family is always going to be marked as the whole of a Component-Whole.

Sentence ID: 8067
Sentence: "One simple <e1>method</e1> for clearing small clogs is to use a tried-and-true <e2>combination</e2> of baking soda and vinegar."
Predicted: Instrument-Agency(e2,e1)
True label: Other
Analysis: This is Purpose-Tool because the combination is the tool for performing the method. The system interprets this as Instrument-Agency because those labels are very similar and there was no training on Purpose-Tool.

Sentence ID: 8070
Sentence: "The following <e1>comments</e1> are provided by <e2>readers</e2> and are the sole responsiblity of the authors."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: The system might think this is an entity origin relationship where the readers are the origin of the comments. It's implied that the comments are produced and didn't already exist but the system can't recognize this implication.

Sentence ID: 8073
Sentence: "The <e1>slide</e1>, which was triggered by an avalanche-control <e2>crew</e2>, damaged one home and blocked the road for most of the day."
Predicted: Cause-Effect(e1,e2)
True label: Cause-Effect(e2,e1)
Analysis: The system probably can't distinguish between 'The slide, which triggered an avalanche-control crew' and 'The slide, which was triggered by an avalanche-control crew'. The first example would result in the Cause-Effect(e1,e2) that was predicted and the only difference is removing two words.

Sentence ID: 8076
Sentence: "Ambassador SUN Shuzhong answered the <e1>questions</e1> from the local <e2>press</e2> after his visit to the Memorial Center in Kigali on Dec. 28, 2007."
Predicted: Other
True label: Product-Producer(e1,e2)
Analysis: The questions being from the press doesn't make it clear what the relationship is. It could be the case that the press is causing the questions or the questions are a component of the press.

Sentence ID: 8078
Sentence: "A Bedouin mediator again returned her when her father promised not to hurt her, and then her <e1>father</e1> killed her with an iron <e2>bar</e2>."
Predicted: Other
True label: Instrument-Agency(e2,e1)
Analysis: The system might think that the father killed her with an iron and thus bar is related to iron but not to father.

Sentence ID: 8081
Sentence: "The safety <e1>bar</e1> of the <e2>seats</e2> has to be folded down by the passenger and it has to be kept closed during the journey."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: The system might not recognize that the bar is a part of the seats. It could also be a product of the seats.

Sentence ID: 8082
Sentence: "By 1715 the cabriole leg was in general use, and the <e1>back</e1> of the <e2>chair</e2> had started to become square in shape: no longer was it the characteristic tall and narrow feature of the previous century."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: Same as 8081. The system might not recognize that the back is a part of the chair. It could also be a product of the chair.

Sentence ID: 8086
Sentence: "Many professional <e1>cartomancers</e1> use a regular deck of playing <e2>cards</e2> for divination."
Predicted: Other
True label: Instrument-Agency(e2,e1)
Analysis: The system might be interpreting the cartomancers as playing the cards rather than using a deck of playing cards. This interpretation is ambiguous so it predicts other.

Sentence ID: 8092
Sentence: "In addition, the <e1>plant</e1> builds four-cylinder "Ecotec" that are used in <e2>vehicles</e2> like the Chevy Malibu and Cobalt."
Predicted: Component-Whole(e2,e1)
True label: Other
Analysis: The vehicles are only related to the plant through the cylinders in this sentence. The system is probably guessing because it also doesn't see the relationship.

Sentence ID: 8093
Sentence: "We used fried <e1>cheese</e1> as an element in a <e2>dish</e2>."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: 'element in a' could be interpreted as Content-Container, Member-Collection, or Component-Whole.

Sentence ID: 8094
Sentence: "The <e1>castle</e1> was inside a <e2>museum</e2>."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: The system probably wasn't sure if the label was Component-Whole or Content-Container.

Sentence ID: 8098
Sentence: "Bunn has recalled 35,600 single-cup pod brewers because the <e1>drawer</e1> of the <e2>coffeemaker</e2> opens unexpectedly during a brew cycle, posing a burn hazard to consumers."
Predicted: Cause-Effect(e1,e2)
True label: Component-Whole(e1,e2)
Analysis: The system is interpreting the drawer to be someone who draws rather than a storage device.

Sentence ID: 8102
Sentence: "The monitoring <e1>station</e1> receives the signal through a communication <e2>device</e2> and the combined signal is processed to retrieve GPS data."
Predicted: Instrument-Agency(e2,e1)
True label: Component-Whole(e2,e1)
Analysis: The device is an instrument but it is not being used by the station, it is being used by someone in the station and is a component of the station.

Sentence ID: 8108
Sentence: "The pretexts offered were laughable, and the <e1>response</e1> caused scarcely a <e2>ripple</e2> on the flood of commentary on Washington's noble "efforts to spread democracy"."
Predicted: Cause-Effect(e2,e1)
True label: Cause-Effect(e1,e2)
Analysis: The system just flip flopped what was causing what.

Sentence ID: 8109
Sentence: "The size of a <e1>tree</e1> <e2>crown</e2> is strongly correlated with the growth of the tree."
Predicted: Component-Whole(e1,e2)
True label: Component-Whole(e2,e1)
Analysis: The only way to know whether tree is a part of crown or crown is a part of tree is the know what a tree crown is. I imagine the system doesn't know.

Sentence ID: 8111
Sentence: "Sci-Fi Channel is the <e1>cable network</e1> exclusively dedicated to offering classic <e2>science fiction TV shows</e2> and movies, as well as bold original programming."
Predicted: Component-Whole(e2,e1)
True label: Other
Analysis: The system thinks the cable network offering TV shows means they're a component of the network but it's actually ambiguous because the network also produces the shows and is the origin of the shows.

Sentence ID: 8116
Sentence: "Lisa took great <e1>joy</e1> from <e2>laughing</e2>, volunteering at school, taking pictures, chatting, the Twins and Vikings, playing softball and volleyball, and time at Lake Vermilion."
Predicted: Other
True label: Cause-Effect(e2,e1)
Analysis: Took X from Y could indicate many relationships. In this case joy and laughing result in Cause-Effect. This is too ambiguous for the system to decipher though.

Sentence ID: 8117
Sentence: "Such <e1>lines</e1> from the pen of a young <e2>author</e2> widely read by the younger part of the population only confirm the profound change in the mood of the Freuch proletariat."
Predicted: Cause-Effect(e2,e1)
True label: Product-Producer(e1,e2)
Analysis: From the pen implies that the pen is doing the producing and the author is causing this. However, the author is actually producing the lines with the pen as the instrument.

Sentence ID: 8118
Sentence: "The <e1>receiver</e1> was outputting the same <e2>tone</e2> to my Deva 5."
Predicted: Other
True label: Cause-Effect(e1,e2)
Analysis: The system isn't sure if outputting means it is Product-Producer, Cause-Effect, or Other.

Sentence ID: 8119
Sentence: "At least 12 people were killed yesterday when a <e1>squad</e1> of heavily armed <e2>militants</e2> stormed the police training school on the outskirts of Lahore, spraying it with gunfire and grenades."
Predicted: Product-Producer(e2,e1)
True label: Other
Analysis: The system might be interpreting armed as a verb: 'The squad armed the bomb'. In that scenario it might interpret the live bomb as being produced by the squad.

Sentence ID: 8122
Sentence: "<e1>Carpenters</e1> build many things from <e2>wood</e2> and other materials, like buildings and boats."
Predicted: Product-Producer(e2,e1)
True label: Instrument-Agency(e2,e1)
Analysis: The system would be correct if e2 was surrounding 'things from wood'. However, wood is the instrument that the carpenter uses to make things so the label is Instrument-Agency. The system isn't making this distinction.

Sentence ID: 8124
Sentence: "There's a comparison between the intimacy and accountability offered by a novel and that offered by a blog in which the <e1>blogger</e1> is participant in an on going <e2>conversation</e2>, in which the line between reader and original poster is blurred beyond recognition, in which collective comment replaces old-fashioned ivory tower editing with a kind of universal peer review."
Predicted: Cause-Effect(e2,e1)
True label: Other
Analysis: The system might be mixing up blog and blogger and thinks the conversation is causing the blog.

Sentence ID: 8127
Sentence: "The <e1>body</e1> unleashes its extraterrestrial <e2>passenger</e2>, which proceeds to infect the student population at a breakneck pace."
Predicted: Instrument-Agency(e2,e1)
True label: Other
Analysis: Based on 'unleash' and 'proceeds to infect', the system is perceiving the passenger as an instrument that the body is unleashing on the student population.

Sentence ID: 8129
Sentence: "In its early years the <e1>farm</e1> had forty <e2>acres</e2>, and was a productive subsistence farm with sheep being the primary source of income."
Predicted: Other
True label: Component-Whole(e2,e1)
Analysis: The system might not be able to tell if the farm is producing the acres, the farm is a component of acres, or the acres are a component of the farm.

Sentence ID: 8131
Sentence: "Gary Wheelan, a womanizing, adulterous thirty-something Dallas attorney, finally gets what he deserves when his verbal assaults provoke a <e1>telephone</e1> <e2>operator</e2>."
Predicted: Instrument-Agency(e2,e1)
True label: Instrument-Agency(e1,e2)
Analysis: The system is probably considering operator to be like a mathematical operator. A mathematical operator would be the instrument in that scenario but in this scenario, the operator is a person who operates the telephone.

Sentence ID: 8136
Sentence: "With our help, non-profit human service <e1>organizations</e1> effectively manage their <e2>resources</e2> and succeed in the modern era of human services."
Predicted: Other
True label: Instrument-Agency(e2,e1)
Analysis: Resources are not typically instruments so the system isn't sure what label to use.

Sentence ID: 8137
Sentence: "The <e1>swim bladder</e1> of aquatic <e2>animals</e2> gives them the ability to manioulate gravity and should be researched more."
Predicted: Other
True label: Component-Whole(e1,e2)
Analysis: The system probably doesn't have enough data to recognize that a swim bladder is a component of an aquatic animal.

Sentence ID: 8142
Sentence: "The GPS network adjustment of <e1>data</e1> from both <e2>epochs</e2> is accomplished using the Ski TM software with constrains network adjustment."
Predicted: Instrument-Agency(e1,e2)
True label: Other
Analysis: Words like 'adjustment' and 'accomplished' might make the system think that an instrument is being used. However, the data is actually an entity from origin epochs, not an instrument.

Sentence ID: 8143
Sentence: "We built this <e1>city</e1> on <e2>rock and roll</e2>."
Predicted: Product-Producer(e1,e2)
True label: Other
Analysis: The system might think that the city is being built by rock and roll. Thus it is the product of rock and roll. However, rock and roll is not a producer.