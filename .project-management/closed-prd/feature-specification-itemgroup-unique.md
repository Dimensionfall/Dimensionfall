There is a bug where a modder Can add the same item to an itemgroup twice 
Steps to reproduce:

    open itemgroup editor on an itemgroup that has meat_jerky in it
    Drop the meat_jerky item onto the itemgroup editor
    Observe there are now two entries for meat_jerky in the itemgroup

We have to enforce that an item can only exist once in an itemgroup (at least until we get nested groups)
In order to to this, we have to examine what `_handle_item_drop` does in `itemgroupeditor.gd` and implement a fix that makes sure an item can only exist in an itemgroup once.
