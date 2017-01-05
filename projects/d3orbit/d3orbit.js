function svgCenter(svg, value) {
    switch(svg[0][0].nodeName) {
        case "circle":
            value && svg.attr("cx", value.x).attr("cy", value.y);
            return { x : Number(svg.attr("cx")), y : Number(svg.attr("cy")) };
        default:
            console.log("svgCenter(): SVG Type '" + svg[0][0].nodeName + "' not supported");
            return { x : 0, y : 0 };
    }
}

function polarToCartesian(r, theta) {
    return {
        x : r * Math.cos(theta),
        y : r * Math.sin(theta)
    };
}

var Orbit = function() {};
Orbit.prototype = {
    initialize : function(satellite, body, distance, period, phase, clockwise) {
        this.satellite = satellite;
        this.body = body;
        this.distance = distance;
        this.period = period;
        this.phase = phase === undefined ? 0 : phase;
        this.clockwise = clockwise === undefined ? false : true;
        this.elapsed = null;
        this.timer = null;
        this.lastFrame = null;
    },
    
    getPosition : function() {
        base = svgCenter(this.body);
        var theta = 2 * Math.PI * ((this.elapsed % this.period) / this.period) + this.phase;
        theta = this.clockwise ? -theta : theta;
        var rp = polarToCartesian(this.distance, theta);
        return { x : base.x + rp.x, y : base.y - rp.y };
    },
    
    startOrbit : function() {
        this.lastFrame = +new Date;
        this.elapsed = 0;
        
        var t = this;
        this.timer = setInterval(function() {
            var now = +new Date();
            t.elapsed += now - t.lastFrame;
            t.lastFrame = now;
            
            var p = t.getPosition();
            svgCenter(t.satellite, p);
        }, 16);

    }
};

