In C++11, one of the most important language feature additions is consecutive right angle brackets not requiring a joining space. This results in vast improvements in code readability:

C++03
	
    std::vector<std::map<std::string, std::pair<int, int> > >::const_iterator

C++11

	std::vector<std::map<std::string, std::pair<int, int>>>::const_iterator
    
Readers are discouraged from using the `auto` keyword as this detracts from the strongly typed nature of C++, and may result in (extra) abusive compiler messages.
