//
//  OnboardingViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/25/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {

    // MARK: - Properties
    lazy var orderedViewController: [UIViewController] = {
        return [self.getViewController(withIdentifier: PageViews.firstPageView.rawValue),
                self.getViewController(withIdentifier: PageViews.secondPageView.rawValue),
                self.getViewController(withIdentifier: PageViews.thirdPageView.rawValue),
                self.getViewController(withIdentifier: PageViews.fourthPageView.rawValue)]
    }()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        
        if let firstViewController = orderedViewController.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate Conformance
extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
   
    func setupPageViewController() {
        self.dataSource = self
        self.delegate = self
    }
    
    func getViewController(withIdentifier identifier: String) -> UIViewController {
        return (storyboard?.instantiateViewController(withIdentifier: identifier))!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return orderedViewController.last }
        
        guard orderedViewController.count > previousIndex else { return nil }
        
        return orderedViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < orderedViewController.count else { return orderedViewController.first }
        
        guard orderedViewController.count > nextIndex else { return nil }
        
        return orderedViewController[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewController.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Enums
    enum PageViews: String {
        case firstPageView
        case secondPageView
        case thirdPageView
        case fourthPageView
    }
    
}
