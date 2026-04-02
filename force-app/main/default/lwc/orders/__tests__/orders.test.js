import { createElement } from '@lwc/jest-helpers';
import Orders from 'c/orders';

describe('c-orders', () => {
    afterEach(() => {
        // Reset DOM between tests since jsdom is shared within the file
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders without error', () => {
        const element = createElement('c-orders', {
            is: Orders
        });
        document.body.appendChild(element);

        // Basic sanity check to ensure element mounted
        expect(element).toBeInstanceOf(HTMLElement);
    });
});
