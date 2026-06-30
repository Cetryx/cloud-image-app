# 9. Part III - Personal Reflection

## 1. What did I learn in this class?

In this class I learned that cloud is not only about "using something online", but that there is a lot behind it. What stayed in my mind from the beginning was the map of the data centers. I found it interesting that many data centers looked like they were connected in a line on the map. I think this probably has something to do with speed or latency, but I am not completely sure. Also the cooling part stayed in my head because I found it really interesting how data centers are cooled. I remember that we talked about the wet towel example and that something similar was already used in Egypt. This made the topic easier to remember for me.

### Summary of the class in my own words

In my own words, the class was about understanding cloud computing from different sides. We talked about traditional data centers, cloud fundamentals, DevOps, Infrastructure as Code, FinOps and Cloud Operations. In Cloud Fundamentals, I remember that different cloud services have different responsibilities and that a company should choose the service depending on what it needs. I also remember the OSI model and the history of cloud, especially that cloud as we know it today is not actually that old. One of the most important points for me was scalability.

From DevOps and Infrastructure as Code, I remember the different process models like waterfall, incremental, prototyping, Extreme Programming, Scrum and the spiral model. Scrum stayed in my mind because many companies use it, even though I personally do not like it that much. Still, I understand that it can be important. I also remember asking a question about Extreme Programming and understanding that it is not really used like that anymore.

Through the project, I also learned more practically how cloud infrastructure can be created with Terraform. Before working with it, I thought Terraform would be much harder to use, but after doing the exercises I understood the basic idea much better. I learned that Terraform can be used to describe infrastructure in code, for example resource groups, storage accounts, containers, Key Vaults and other Azure resources. What I found interesting was that I did not have to click everything manually in the Azure Portal, but could write the desired infrastructure in code and then use terraform plan and terraform apply (the UI was sometimes confusing, but it definietly helped me understand what the different features do).

### My personal take-aways and transfer to other classes

My personal takeaway is that cloud computing is much broader than I expected. It is not only technical, but also about costs, processes, responsibilities and operations. FinOps showed me that cloud can become very expensive without a good team and without cost awareness. The lift-and-shift shot clock stayed in my mind because of the basketball example. Cloud Operations also felt useful for later, because if a company wants to move systems to the cloud, a migration roadmap and the different options like re-host, re-platform or re-architect are important.

One thing I transferred to other classes without really noticing it at first was the idea of prototyping. Before, I sometimes thought too much before starting a task. Now I more often just start with a first version and improve it step by step. This helped me because I do not wait until everything is perfect before beginning. I can create something simple first, test it, and then change or improve it later.

## 2. Why is Cloud Computing important?

Cloud computing is important because companies can provide infrastructure and services much faster without buying and maintaining all hardware themselves. Instead of setting up everything manually in a data center, they can use cloud resources like storage, web apps, Key Vaults or databases when they need them.

For me, one of the most important points is scalability. If demand increases, resources can be scaled. If demand decreases, resources can be reduced again. This makes cloud computing useful for companies that need to react quickly to changes.

Cloud computing is also important because different services can be connected with each other. For example, in our project, infrastructure, storage, secrets, identity and pipelines were connected. This showed me that cloud is not only about creating one resource, but about building a working environment. At the same time, topics like Identity and Access Management, secrets management and cost control are important, because cloud resources can become expensive or insecure if they are not managed properly.

### Summary of the key points highlighted in this class

The main points of the class were cloud fundamentals, DevOps, Infrastructure as Code, FinOps and Cloud Operations. I learned about service models like IaaS, PaaS and SaaS, scalability, Terraform, cloud costs and different migration strategies.

A key point was that cloud resources are flexible and scalable, but they also need to be managed properly. Automation with Terraform and pipelines can reduce manual errors and make deployments more repeatable. Another important point was that Identity and Access Management is central in cloud projects. Secrets should not be written directly into the code, but stored securely, for example in a Key Vault.

The class also showed that cloud computing is connected to cost and operations. Resources like VMs or App Service Plans can create costs while they are running, so cost control is important. Overall, the class showed me that cloud computing is not only technical, but also connected to responsibility, security, automation, cost and operations.

### Why did it make sense for me to take this class?

It made sense for me to take this class because cloud computing was already a topic I had heard about many times before. I often heard about AWS, Azure, Salesforce and cloud certifications, and I noticed that many people online talk about cloud skills as something important for IT jobs. This made me realize that cloud is not just a trend, but an important topic for many companies.

The AI boom also made cloud more interesting for me. Since many companies now work with large amounts of data and use artificial intelligence, I wanted to understand how cloud infrastructure supports these topics. Before the class, cloud was more like a buzzword for me. After the lectures and the Terraform project, I understand much better why companies use cloud and how cloud resources can be created and managed.

## 3. What are the advantages and disadvantages of the Cloud Computing model?

### Advantages

- Fast provisioning of infrastructure and services.

- Companies do not always need their own server room or hardware.

- Many ready-made services are available, for example storage, databases, app services or AI services.

- Resources can be scaled depending on demand.

- Infrastructure can be automated with Infrastructure as Code and pipelines.

- Cloud offers central security mechanisms like RBAC and Managed Identity.

- Companies can test ideas and build applications faster.

### Disadvantages

- Cloud can become expensive if resources keep running without being used.

- Permissions, roles and identities can be difficult to understand at the beginning.

- Companies can become dependent on one cloud provider.

- Troubleshooting can be complex because application, identity, network, infrastructure and pipeline can all be connected.

- Wrong configurations can create security problems.

- Not every application is automatically cloud-ready.

### When would I suggest a company to use Cloud Computing?

- When a company needs flexibility and wants to react quickly to changes.

- When a company needs scalability, for example if user demand goes up and down.

- When a company wants to build or test new applications quickly.

- When a company wants to use managed services like storage, databases, app services or AI services.

- When a company does not want to operate all hardware and server rooms by itself.

- When infrastructure should be automated with tools like Terraform and pipelines.

### When would I suggest a company to do something else?

- When an application is not cloud-ready.

- When an application already runs stable and cheaply on-premises.

- When there are very strict security, compliance or data protection requirements.

- When very low latency is needed and a local solution would work better.

- When the company does not have enough cloud knowledge yet.

- When the company would only do lift-and-shift without a real plan.
