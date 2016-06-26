<?php
namespace AppBundle\DataFixtures\ORM;

use Doctrine\Common\DataFixtures\FixtureInterface;
use Doctrine\Common\Persistence\ObjectManager;
use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use AppBundle\Entity\User;

class LoadUserData implements FixtureInterface,ContainerAwareInterface
{
    private $container;

    public function setContainer(ContainerInterface $container = null)
    {
        $this->container = $container;
    }

    public function load(ObjectManager $objectManager)
    {
        $user = new User();
        $user->setEmail('admin1234@example.com');
        $user->setFullName('admin user');
        $user->setIsActive(true);

        $password = 'admin123';

        //get encoder
        $encoder = $this->container->get('security.password_encoder');
        $encodedPassword = $encoder->encodePassword($user,$password);
        $user->setPassword($encodedPassword);

        $objectManager->persist($user);
        $objectManager->flush();

    }
}