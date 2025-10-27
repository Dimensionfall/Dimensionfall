When right-clicking an item in the inventory, the users sees all available options for the item, even the ones that don't apply. This causes one to reload a wooden stick, which makes no sense.

The context menu lives in CtrlInventoryStackedCustom.tscn. There is already some logic implemented that decides what context menu options will be disabled.

However, instead of the context menu options being disabled, they should be hidden completely from the context menu.
