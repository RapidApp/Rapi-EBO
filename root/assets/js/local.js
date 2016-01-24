Ext.ns('RA.ux.EBO');

RA.ux.EBO.renderColorName = function(v) {
  //return ['<b style="color:',v,';">',v,'</b>'].join('');
  
  return [
    '<span style="',
      'display:inline-block;',
      'width:16px;',
      'margin-right:7px;',
      'background-color:',v,';',
      'border: 1px solid #D0D0D0;',
     '">&nbsp;</span>',v
  ].join('');
};

// algorithm for generating the data structure of a multi-line Chart.js graph
RA.ux.EBO.lineCharter = function(cnf) {
  if(
    Ext.isObject(cnf) &&
    Ext.isString(cnf.value_column) && // numeric values on the left/y-axis
    Ext.isString(cnf.point_column) && // labels on the bottom/x-axis
    Ext.isString(cnf.group_column)    // each line
  ) {}
  else { throw "bad options"; }
  
  this.cnf = cnf;
  
  this.cfgForRows = function(rows) {
  
    if(!Ext.isArray(rows)) { throw [
      "Bad arguments - expected an array"
    ].join(''); }    
  
    var points = { order: [], count: {} };
    var groups = { order: [], count: {} };
    
    var pgv = {};
    
    Ext.each(rows,function(row,i) {
    
      if(!Ext.isObject(row)) { throw [
        "Bad row at index ",i," - not an object"
      ].join(''); } 
      
      // -- Validate each row has all three needed data-points --
      if(typeof row[cnf.value_column] == 'undefined') { throw [
        "Bad data - missing value column '",cnf.value_column,"' (row index: ",i,')'
      ].join('') }
      if(typeof row[cnf.point_column] == 'undefined') { throw [
        "Bad data - missing point column '",cnf.point_column,"' (row index: ",i,')'
      ].join('') }
      if(typeof row[cnf.group_column] == 'undefined') { throw [
        "Bad data - missing group column '",cnf.group_column,"' (row index: ",i,')'
      ].join(''); }
      // --
      
      var v = row[cnf.value_column], p = row[cnf.point_column], g = row[cnf.group_column];
      
      points.count[p] = points.count[p] || 0;
      groups.count[g] = groups.count[g] || 0;
      
      points.count[p]++ || points.order.push(p);
      groups.count[g]++ || groups.order.push(g);
      
      pgv[p] = pgv[p] || {};
      
      if(typeof pgv[p][g] != 'undefined' && pgv[p][g] != v) { throw [
        "Duplicate conflicting value '",v,"' for point '",p,
        "', group '",g,"' (row index: ",i,')'
      ].join(''); }
      
      pgv[p][g] = v;

    },this);
    
    var group_vals = {};
    
    Ext.each(points.order,function(p) {
      Ext.each(groups.order,function(g) {
      
        // Make sure we have a value for each point/group:
        if(typeof pgv[p][g] == 'undefined') { throw [
          "Bad data - missing value for group '",g,"' at point '",p,"'"
        ].join(''); }
        
        group_vals[g] = group_vals[g] || [];
        group_vals[g].push( pgv[p][g] );
        
      },this);
    },this);
    
    var chartData = {
      labels   : points.order,
      datasets : []
    };
    
    Ext.each(groups.order,function(g) {
      // TODO: populate options such as line color, etc...
      
      var dataset = {
        label : g,
        data  : group_vals[g]
      };
      
      chartData.datasets.push( dataset );
    },this);
    
    return chartData;
  
  };
}