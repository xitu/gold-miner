<h1>event.stopPropagation() in a modular system</h1>

![](https://www.moxio.com/documents/gfx/page_images/blog.header_1.png)
Here at Moxio we build web applications from modules that we call widgets. A widget contains some logic and it controls a little bit of HTML. Think of a checkbox input element or a list of other widgets. A widget can declare what data or dependencies it needs and can choose to pass resources down to its children. Modularity is great for managing complexity because all channels of communication are explicitly defined. It also allows you reuse widgets by combining in different ways. JavaScript makes it a little bit difficult to ensure a modular contract because you always have access to a global scope but it can be managed.

Modular design in JavaScript
----------------------------

Native JavaScript APIs are not really designed with modularity in mind; by default you have access to the _global_ scope. We make global resources available to widgets by wrapping them at the root level and passing them down. We have wrappers for resources such as LocalStorage, the page URL and the viewport (for looking at page coordinates). We also wrap DOMElements and Events. With our wrappers we can restrict or alter functionality so we keep the modularity contract intact. For instance: a click event may know whether the shift-key was pressed but you can't know the target of the click event, which may be in another widget. This might seem very restrictive, but so far we haven't found a need to expose the target directly.

For every feature we find a way to express it without breaking the modularity contract. This leads us into my analysis of `event.stopPropagation()`. Do we need it, and how can we provide its functionality?

stopPropagation example
-----------------------

Consider this example HTML:

    <div class="table">
    	<div class="body">
    		<div class="row open">
    			<div class="columns">
    				<div class="cell">
    					<span class="bullet"></span>
    					<input type="checkbox" />
    					Lorem ipsum dolor sit amet
    				</div>
    				<div class="cell"><a href="/lorem-ipsum">Lorem ipsum</a></div>
    			</div>
    			<div class="contents">
    				<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
    			</div>
    		</div>
    		<!-- more rows -->
    	</div>
    </div>

With some CSS magic it looks like:

![](/documents/gfx/blog.stoppropagation.png)

We have the following interactions:

*   clicking the checkbox will check or uncheck the checkbox and make the row "selected"
*   clicking the link in the second cell opens that location
*   clicking the row will open or close the row showing "contents"

### JavaScript event model

A quick refresher on how events work in JavaScript: when you click on an element (for instance a checkbox) an event spawns and first travels down the tree: table > body > row > columns > cell > input. This is the capturing phase. Then the event travels back up in reverse order, this is the bubble phase: input > cell > columns > row > body > table.

The implication of this is that a click on the checkbox causes a click event on the checkbox _and_ on the row. We don't expect that clicking the checkbox will also toggle the row so we need to detect this. This is where stopPropagation comes in.

    function on_checkbox_click(event) {
    	toggle_checkbox_state();
    	event.stopPropagation(); // prevent this event from bubbling up
    }

If you `event.stopPropagation()` in the click listener of the checkbox in the bubbling phase the event will no longer bubble up and it will never reach the row. This is a straightforward way to implement the desired interaction.

Undesirable interactions
------------------------

Using stopPropagation has a side effect however. Clicks on the checkbox don't make it back up to the top _at all_. Our intent was to block the click on the row but we blocked it for _all_ our parents. Let's say for instance we have an open menu that needs to collapse when you click 'somewhere else on the page'. Suddenly a straightforward click listener doesn't work anymore because our click events might 'disappear'. We could use the capturing phase but what's to stop a widget above us from blocking _that_ event? stopPropagation gives us a conflict in our modularity contract. It seems desirable that **widgets should not be allowed to interfere with event propagation** during capturing or bubbling.

If we were to remove support for stopPropagation from our wrapper, can we still make an implementation for our row interactions? We can, but it's messy. We can do some bookkeeping so we know when to ignore a click event on the row, or we could open up the event target, or we could allow inspection of where the event has been. We have experimenting with some solutions but we don't really like them.

Bookkeeping workaround example:

    var checkbox_was_clicked = false;
    
    function on_checkbox_click() {
    	checkbox_was_clicked = true;
    	handle_checkbox_click();
    }
    
    function on_row_click() {
    	if (checkbox_was_clicked === false) {
    		handle_row_click();
    	}
    	checkbox_was_clicked = false;
    }

You can see how this workaround becomes cumbersome if we have more elements that we want to block clicks from (such as the link in the second column), or if the element is in a sub-widget.

A conceptual solution
---------------------

We can do better. There is a concept here. We haven't found a good name for it yet but consider it something like a 'significant action'. When you click you always have at most one significant action: either you toggle the row or the checkbox, but never both. From a UX design point of view this makes a lot of sense. My first thought was that stopPropagation shouldn't cancel the bubble but instead it sets a flag on the event that indicates that a significant action has already been executed. A drawback is that for every interactable element (checkboxes, links, buttons etc.) you still need to add a click handler that sets the significant flag. That seems like a lot of work. We can do a little bit better: for interactable elements we already know that they have a signification action, so if the target of an event is an interactable element we can set the significant flag automatically. With this logic being performed in our event wrapper, the row now only needs to check the significant flag so we can ignore clicks from the checkbox in the first column and the link in the second column.

We can now implement our row click handler as such:

    function on_row_click(event) {
    	if (event.is_handled() === false) { // this event had no significant action
    		toggle_row_open_state();
    	}
    }

Conclusion
----------

I'm often amazed at the foresight in the design of JavaScript and its native libraries. In general things work really well. It's a kind of 'choose your own adventure' style API that supports many workflows, including ours. Our modular design and wrapping allows us to augment the native libraries with our own concepts. We can fill in the gaps and smooth out the bumps.

We still allow stopPropagation but discourage its use. The significant-flag has been implemented in many a checkbox-table and there was much rejoicing.
