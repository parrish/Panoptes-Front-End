import React from 'react'
import assert from 'assert'
import SVGImage from './svg-image'
import {shallow, render} from 'enzyme'

describe('SVGImage', function(){
  it('should render without crashing', function(){
    shallow(<SVGImage src="barfoo.png" width={100} height={100} />)
  });

  it('it should contain an image element', function(){
    const filename = 'foobar.jpeg'
    const wrapper = render(<SVGImage src={filename} width={100} height={100} />);
    const image = wrapper.find('image');

    assert(image.length, 1);

    assert(image.attr('xlink:href', filename));

  });

});