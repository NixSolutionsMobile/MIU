![GitHub Logo](/images/logo.png)

# MIU
## An Objective-C macOS application specializing in quick generation of boilerplate model methods

MIU is an application for Mac OS that simplifies the generation of methods for model classes. Written in Objective-C, the application does the following tasks:
- submits a class to protocols NSCopying и NSCoding
- generates methods ( isEqual, description, hash, initWithCoder, encodeWithCoder, copyWithZone )
- performs model condition analysis

MIU combines a simple, intuitive interface with broad capacities to simplify your work.

# Usage
---

MIU gives an opportunity to add Xcode projects, and it is also possible to filter already added projects for fast and convenient search. To add a project, all you need is to click the button ![GitHub Logo](/images/newProjectBtn.png) and select the folder where the project is stored. The project name will be defined by the application automatically, but it can also be changed manually. If the project has already been added, you can change its name by right-clicking the context menu. 
Double-click on the icon or choose the item from context menu and start the project. 
Choose either “Rename” or “Remove”.

![GitHub Logo](/images/gifs/addingProject.gif)

# Important
---

>* The generation of a new method will not occur if a predetermined method is available. In this case, it is necessary to delete the method manually and launch the methods generation. 

> * When there is an unknown data type during the generation of methods, a warning will be added at the end of the method to notify the developer if there is a need to recheck the generated method.

>* If you decide to redefine the methods that was generated, just delete the tag ![GitHub Logo](/images/generatedMark.png)  in front of the body and MIU will no longer recognize this method. 


>* Generating methods for two classes that store a link in the form of a property for each other leads to a closed loop situation of the generated methods call. 

>* ![GitHub Logo](/images/cicleMethodCallExmpl.png)
---

# Reference book

##### Buttons:
![GitHub Logo](/images/launchGeneration.png) – Launching the generation methods of classes

![GitHub Logo](/images/analyzeClasses.png) – Analyzing classes on the chosen paths 

![GitHub Logo](/images/addOrDeletePathes.png) – Adding or deleting a method for models 

![GitHub Logo](/images/sortResults.png) – Sorting the results of the generation 

##### Results:
After the generation/analysis, the data of classes and their methods will be shown in the table 

![GitHub Logo](/images/gifs/analyzingAndGenerating.gif)

![GitHub Logo](/images/afterGenerationState.png)


The application records data about the class. You will be warned if the class is outdated and it needs regeneration of methods. MIU displays the outdated classes in yellow. 

![GitHub Logo](/images/warnedAfterGeneration.png)


UI element                                              | Result of generation
:------------------------------------------------------:|:------------------------------------
![GitHub Logo](/images/supported_by_user.png)           | The method is implemented by a user 
![GitHub Logo](/images/regenerated_icon.png)            | The method was regenerated 
![GitHub Logo](/images/generate_with_warnings_icon.png) | The method was generated with warnings     
![GitHub Logo](/images/not_changed_icon.png)            | The method has already been implemented         
![GitHub Logo](/images/first_generation_icon.png)       | The method was successfully generated

The method is analyzed for two conditions. 
The method may be generated or it may not be implemented at all.
If there is no defined method in the implementation of the class, there is a gap in the relevant column. 
![GitHub Logo](/images/notDefinedMethods.png)

![GitHub Logo](/images/gifs/generating.gif)

## Install
1. [Download latest version](https://github.com/NixSolutionsMobile/MIU/releases/tag/v1.0.0)
2. Move `MIU.app` to `Applications` folder
3. Use it :)

## License
`MIU` is made for [NIXSolutions LTD](https://www.nixsolutions.com) by the iPhone department and it is available under the MIT license.

## Contributing
We welcome all contributions. Feel free to submit pull request or create an issue.

