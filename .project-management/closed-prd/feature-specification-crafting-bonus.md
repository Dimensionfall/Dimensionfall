
As of #807, intelligence counts a as a bonus for required skill on crafting items. I want to make this moddable.

1. modify item crafting editor and create a field that will allow the user to enter a stat. This stat will give a bonus to the required skill of the craftable item. For example, if `fabrication` skill is 5 and `intelligence` is 5, the calculations will count it as though the `fabrication` skill is 10.
2. Modify DItem and RItem to support this property. This includes making sure that the references are updated between stats and items
3. Modify crafting recipes manager to read the stat bonus property instead of using the hardcoded `intelligence`
