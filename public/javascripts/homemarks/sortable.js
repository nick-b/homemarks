
var SortableUtils = {
  
  getOldNewSort: function(element) {
    var dragObserver = Draggables.observers.find(function(d){ return d.element == element }.bind(this));
    var oldSort = dragObserver.lastValue.toQueryParams()[element.id+'[]'];
    var newSort = Sortable.sequence(element.id);
    return {old:oldSort,now:newSort};
  },
    
  getSortParams: function(element) {
    var sort = SortableUtils.getOldNewSort(element);
    // Doing the work to find which and where the droppable was moved to.
    if (sort.old.length == sort.now.length) { /* Find the change within the sortable */
      sort.old.each(function(id,index) {
        if (id != sort.now[index]) { 
          /* Check to see if the droppable was moved down */
          if (sort.old[index+1] == sort.now[index]) { drop_id = id; drop_position = sort.now.indexOf(id)+1; };
          /* Check to see if the droppable was moved up */
          if (sort.old[index] == sort.now[index+1]) { drop_id = sort.now[index]; drop_position = index+1; };
          throw $break;
        };
      });
      var params = { id:parseInt(drop_id), position:parseInt(drop_position) };
      return $H(params);
    }
    else { 
      return false; 
    }
  }
  
  // KILLING A SORTABLE ITEM (cherry pick from Sortable.destroy)
  //   * var sortable = Sortable.sortables['col_wrapper']
  //   * sortable.droppables                  # Detect first with element == "column".
  //                                            sortable.droppables = sortable.droppables.without("column")
  //   * Droppables.remove(element)           # Pass "column" element to this function.
  //   * sortable.draggables                  # Detect first with obj.element == "column". Then call destroy() on it.
  //   * sortable.draggables                    sortable.draggables = sortable.draggables.without("column")
  
  // SOME NOTES TO SELF:
  /* onUpdate: function(event) { 
       new Ajax.Request('/columns/sort', { asynchronous:true, parameters:findSortedInfo(this) });
     }
     
     Sortable.sortables     => [elements]
     Sortable.sortables['col_wrapper']
       #draggables          => [Draggable.elements]
       #droppables          => [element(containment),draggable.elements]
     
     Sortable.sequence($('col_wrapper'))
     
     Draggables.drags
     
     Draggables.observers
     Draggables.observers['col_wrapper']
     
     Droppables.drops
  */
  
};

