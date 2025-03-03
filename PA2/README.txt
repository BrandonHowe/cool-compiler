The general pipeline is as follows:
- Parse the AST from text into a bunch of structs
- Convert the AST class nodes into an array of custom ClassNode -- these include predefined classes like Object or Int, and also encode the data in a form better suited for type checking. We only fill in the class names for now as a first pass
- Use insertion sort to generate a sorted list of classes (used later)
- Check for inheritance cycles using DFS
- For each ClassNode, fill in all its attributes by looking at its parent's attributes, and then add the ones defined in the AST. If there's an error in this process it gets returned.
- Repeat the process but for filling in methods.
- Write the sorted array of classes to the output file in order
- Write the implementation map of classes to the output file in order. This performs type checking
- Write the parent map of classes to the output file in order
- Write the annotated AST to the output file in order. This performs type checking again

I chose to represent the class hierarchy as a linear array of classes, with each class having a pointer to its parent. I made each class contain a copy of all its methods inherited or not, which makes things like static dispatch and checking method environments easier but turned out to use a lot more memory -- for instance, each class contains the 3 methods that it inherits from Object! I also hardcoded the first 5 built in classes as being Object, Bool, Int, String, IO.

To type check expressions I used a recursive approach and essentially had one big switch statement to type check expressions. I used a custom pool allocator to manage the entire object environment so maintaining all the lifetimes was easy and fast. My type struct contained the type name and then the self type base class if the type name was SELF_TYPE. Since there are no modules, there can never be any 2 types with the same name, so using strings as type identifiers worked fine. I honestly didn't feel like there was anything particularly difficult about handing any of the individual expressions like case, new, and dispatch -- my new code was only like 4 lines and the case and dispatch code was quite straightforward. Most of the difficulty in type checking came from handling SELF_TYPE -- I didn't have a super thought-out approach to handling it and it took a lot more effort than I needed to.

For memory management I felt the simplest approach was to just create a big arena allocator and dump all my allocations in there, most of the allocations have a similar lifetime anyways and I felt this was the best solution. I also created two string types (one owning and one non-owning), with the owning one only being used for writing to files. Most of the strings we need are in the AST anyways so string views work fine in almost all cases.

Test cases:
- good1.cl -- I spent a really long time figuring out SELF_TYPE, in particular whether to print SELF_TYPE or the actual type name in the AST. The test case stresses a bunch of the SELF_TYPE mechanics and makes sure they all work properly. It also contains a test for variable shadowing and making sure that compiles properly
- bad1.cl -- Checks binary expressions like addition and also contains some valid code regarding SELF_TYPE
- bad2.cl -- Makes sure that arguments are subtypes of parameters and not the other way around, and checks the subtyping relation in general
- bad3.cl -- Checks that identifiers are always defined and that no undeclared ones slip through