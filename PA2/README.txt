The general pipeline is as follows:
- Parse the AST from text into a bunch of structs
- Convert the AST class nodes into an array of custom ClassNode -- these include predefined classes like Object or Int, and also encode the data in a form better suited for type checking. We only fill in the class names for now as a first pass
- Use insertion sort to generate a sorted list of classes (used later)
- Check for inheritance cycles using DFS
- For each ClassNode, fill in all its attributes by looking at its parent's attributes, and then add the ones defined in the AST. If there's an error in this process it gets returned.
- Repeat the process but for filling in methods.
- Write the sorted array of classes to the output file in order

I chose to represent the class hierarchy as a linear array of classes, with each class having a pointer to its parent. I made each class contain a copy of all its methods inherited or not, which makes things like static dispatch easier but turned out to use a lot more memory -- for instance, each class contains the 3 methods that it inherits from Object!

For memory management I felt the simplest approach was to just create a big arena allocator and dump all my allocations in there, most of the allocations have a similar lifetime anyways and I felt this was the best solution. I also created two string types (one owning and one non-owning), with the owning one only being used for writing to files. Most of the strings we need are in the AST anyways so string views work fine in almost all cases.