//Ext.ns('RA.ux.EBO');

var RA = RA || {};
RA.ux = RA.ux || {};
RA.ux.EBO = RA.ux.EBO || {};


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
  if(!Ext.isObject(cnf)) { throw [
    "Bad options - constructor requires object/config"
  ].join('') }
  
  // value_column: numeric values on the left/y-axis
  if(!Ext.isString(cnf.value_column)) { throw [
    "Bad options - 'value_column' missing or is not a string"
  ].join('') }
  
  // point_column: labels on the bottom/x-axis
  if(!Ext.isString(cnf.point_column)) { throw [
    "Bad options - 'point_column' missing or is not a string"
  ].join('') }
  
  // group_column: each line
  if(!Ext.isString(cnf.group_column)) { throw [
    "Bad options - 'group_column' missing or is not a string"
  ].join('') }
  
  // group_rgb_map: RGB color to use for the line by group_name
  if(!Ext.isObject(cnf.group_rgb_map)) { throw [
    "Bad options - 'group_rgb_map' missing or is not an object"
  ].join('') }
  
  
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
      
      // Make sure we were supplied with the color to use for this group
      if(typeof cnf.group_rgb_map[g] == 'undefined') { throw [
         "Bad data - no group_rgb_map entry for seen group/line name '",g,"' (row index: ",i,')'
      ].join('') }
      
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
    
      var rgb = cnf.group_rgb_map[g];
      
      if(!Ext.isArray(rgb) || rgb.length != 3) { throw [
         "Bad group_rgb_map entry for group/line name '",g,"' - not a 3-element array"
      ].join('') }
      
      var dataset = this.lineColorCfgForRGB(rgb);
      
      dataset.label = g;
      dataset.data  = group_vals[g]
      
      chartData.datasets.push( dataset );
    },this);
    
    return chartData;
  
  };
  
  this.lineColorCfgForRGB = function(rgb) {
    var rgb_str = rgb.join(',');
    return {
      fillColor: "rgba("+rgb_str+",0.2)",
      strokeColor: "rgba("+rgb_str+",1)",
      pointColor: "rgba("+rgb_str+",1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba("+rgb_str+",1)",
    };
  };
  
}